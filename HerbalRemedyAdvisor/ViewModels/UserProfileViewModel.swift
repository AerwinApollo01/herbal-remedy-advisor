import Combine
import Foundation

// MARK: - UserProfileViewModel

/// Owns all monetization access state for the authenticated user:
/// - `isLifetimeArchiveUnlocked` — true after a StoreKit 2 lifetime purchase
/// - `availableTokens`          — earned tokens, each spendable for one protocol unlock
/// - `unlockedProtocolIDs`      — set of protocol IDs the user has individually unlocked
///
/// Injected as an `@EnvironmentObject` from `HerbalRemedyAdvisorApp`.
/// ViewModels and views call `isProtocolAccessible(_:)` to gate content.
@MainActor
final class UserProfileViewModel: ObservableObject {

    // MARK: Published state

    @Published private(set) var isLifetimeArchiveUnlocked: Bool  = false
    @Published private(set) var availableTokens:           Int   = 0
    @Published private(set) var unlockedProtocolIDs:       Set<String> = []

    @Published private(set) var isLoading:   Bool   = false
    @Published private(set) var errorMessage: String? = nil

    // MARK: Private

    private var userID: String?

    // MARK: Lifecycle

    func configure(userID: String) {
        self.userID = userID
        Task { await fetchProfile() }
    }

    // MARK: - Access logic

    /// Returns `true` if the user can freely view the given protocol.
    /// Rules:
    ///   1. Lifetime archive unlocked → always accessible.
    ///   2. Protocol is a starter volume → always accessible.
    ///   3. Protocol ID is in `unlockedProtocolIDs` → accessible.
    ///   4. Otherwise → locked; show the gate overlay.
    func isProtocolAccessible(_ protocol: NysProtocol) -> Bool {
        if isLifetimeArchiveUnlocked          { return true }
        if `protocol`.isStarterVolume         { return true }
        if unlockedProtocolIDs.contains(`protocol`.id) { return true }
        return false
    }

    /// Convenience overload for local Remedy objects (uses name as fallback ID).
    func isRemedyAccessible(_ remedy: Remedy, protocolID: String? = nil) -> Bool {
        if isLifetimeArchiveUnlocked { return true }
        let pid = protocolID ?? remedy.name
        if unlockedProtocolIDs.contains(pid) { return true }
        // Local catalog entries are treated as starter volumes for now
        return true
    }

    // MARK: - Session lifecycle

    /// Wipes all sensitive in-memory state when a session expires or is revoked.
    ///
    /// Called by `HerbalRemedyAdvisorApp` in response to the `nysSessionDidExpire`
    /// notification posted by `AuthViewModel`'s live session guard. Zeroing these
    /// fields prevents stale monetization state from remaining resident in memory
    /// after a Firebase token revocation event.
    func clearSensitiveState() {
        isLifetimeArchiveUnlocked = false
        availableTokens           = 0
        unlockedProtocolIDs       = []
        userID                    = nil
        errorMessage              = nil
    }

    // MARK: - Firestore sync

    func fetchProfile() async {
        guard let uid = userID else { return }
        isLoading = true
        errorMessage = nil
        do {
            if let profile = try await FirestoreService.shared.fetchUserProfile(uid: uid) {
                apply(profile)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func apply(_ profile: UserProfile) {
        isLifetimeArchiveUnlocked = profile.isLifetimeArchiveUnlocked
        availableTokens           = profile.availableTokens
        unlockedProtocolIDs       = Set(profile.unlockedProtocolIDs)
    }

    // MARK: - Monetization actions

    /// Called by `PurchaseManager` after a verified StoreKit 2 transaction.
    /// Writes to Firestore and updates local state optimistically.
    func applyLifetimeUnlock() async {
        guard let uid = userID else { return }
        isLifetimeArchiveUnlocked = true   // optimistic
        do {
            try await FirestoreService.shared.setLifetimeArchiveUnlocked(uid: uid)
        } catch {
            // Roll back optimistic update on failure
            isLifetimeArchiveUnlocked = false
            errorMessage = error.localizedDescription
        }
    }

    /// Spends one token to unlock a specific protocol, using a Firestore transaction.
    func spendTokenToUnlock(protocolID: String) async {
        guard let uid = userID, availableTokens > 0 else {
            errorMessage = "No tokens available."
            return
        }
        // Optimistic local update
        availableTokens -= 1
        unlockedProtocolIDs.insert(protocolID)
        do {
            try await FirestoreService.shared.spendTokenToUnlockProtocol(uid: uid, protocolID: protocolID)
        } catch {
            // Roll back
            availableTokens += 1
            unlockedProtocolIDs.remove(protocolID)
            errorMessage = error.localizedDescription
        }
    }

    /// Optimistically reflects a new lifetime unlock from StoreKit without a Firestore round-trip.
    func markLifetimeUnlockedLocally() {
        isLifetimeArchiveUnlocked = true
    }
}
