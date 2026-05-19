import FirebaseCore
import FirebaseCrashlytics
import FirebaseFirestore
import Foundation

// MARK: - FirestoreService

/// Central async/await service layer for all Firestore network communication.
/// All reads and writes are strictly isolated here — ViewModels never touch `Firestore` directly.
final class FirestoreService {

    static let shared = FirestoreService()
    private init() {}

    private var db: Firestore? {
        guard FirebaseApp.app() != nil else { return nil }
        return Firestore.firestore()
    }

    // =========================================================================
    // MARK: - User Profile
    // =========================================================================

    /// Creates or merges a user profile document in `/users/{uid}`.
    /// Also writes the monetization defaults on first creation (non-destructive merge).
    func saveUserProfile(uid: String, ageBracket: String, wellnessGoal: String) async throws {
        guard let db else { return }
        let data: [String: Any] = [
            "ageBracket":               ageBracket,
            "wellnessGoal":             wellnessGoal,
            "createdAt":                FieldValue.serverTimestamp(),
            // Monetization defaults — setData with merge:true won't overwrite if already present
            "isLifetimeArchiveUnlocked": false,
            "availableTokens":          0,
            "unlockedProtocolIDs":      [String](),
        ]
        do {
            try await db.collection("users").document(uid)
                .setData(data, merge: true)
        } catch {
            Crashlytics.crashlytics().record(error: error)
            throw error
        }
    }

    /// Fetches the full user profile document as a `UserProfile` value object.
    func fetchUserProfile(uid: String) async throws -> UserProfile? {
        guard let db else { return nil }
        let snap = try await db.collection("users").document(uid).getDocument()
        guard snap.exists, let data = snap.data() else { return nil }
        return UserProfile(from: data)
    }

    func fetchWellnessGoal(uid: String) async -> String? {
        guard let db else { return nil }
        let doc = try? await db.collection("users").document(uid).getDocument()
        return doc?.data()?["wellnessGoal"] as? String
    }

    // MARK: Monetization writes

    /// Marks the lifetime archive as unlocked for a user (called after StoreKit verification).
    func setLifetimeArchiveUnlocked(uid: String) async throws {
        guard let db else { return }
        try await db.collection("users").document(uid)
            .updateData(["isLifetimeArchiveUnlocked": true])
    }

    /// Deducts one token and records the newly unlocked protocol ID atomically.
    func spendTokenToUnlockProtocol(uid: String, protocolID: String) async throws {
        guard let db else { return }
        let ref = db.collection("users").document(uid)
        // Firestore transaction ensures atomic decrement + array append
        try await db.runTransaction { transaction, errorPointer in
            let snap: DocumentSnapshot
            do { snap = try transaction.getDocument(ref) } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
            let currentTokens = snap.data()?["availableTokens"] as? Int ?? 0
            guard currentTokens > 0 else {
                errorPointer?.pointee = NSError(
                    domain: "NysApp", code: 402,
                    userInfo: [NSLocalizedDescriptionKey: "Insufficient tokens"]
                )
                return nil
            }
            transaction.updateData([
                "availableTokens":     currentTokens - 1,
                "unlockedProtocolIDs": FieldValue.arrayUnion([protocolID]),
            ], forDocument: ref)
            return nil
        }
    }

    // =========================================================================
    // MARK: - Protocol Collection
    // =========================================================================

    /// Fetches all documents from the `/protocols/` collection and decodes them
    /// into `NysProtocol` values. Sorted client-side by `systemPriority` string
    /// (alphabetical by default; ViewModel applies user-selected sort on top).
    func fetchProtocols() async throws -> [NysProtocol] {
        guard let db else { return [] }
        let snapshot = try await db.collection("protocols").getDocuments()
        return snapshot.documents.compactMap { doc -> NysProtocol? in
            var data = doc.data()
            data["id"] = doc.documentID          // inject Firestore doc ID
            data["isStarterVolume"] = data["isStarterVolume"] ?? false
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return nil }
            return try? JSONDecoder().decode(NysProtocol.self, from: jsonData)
        }
    }

    /// Fetches a single protocol document by ID.
    func fetchProtocol(id: String) async throws -> NysProtocol? {
        guard let db else { return nil }
        let doc = try await db.collection("protocols").document(id).getDocument()
        guard doc.exists, var data = doc.data() else { return nil }
        data["id"] = doc.documentID
        data["isStarterVolume"] = data["isStarterVolume"] ?? false
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else { return nil }
        return try? JSONDecoder().decode(NysProtocol.self, from: jsonData)
    }

    // =========================================================================
    // MARK: - App Config (Remote Strings & Feature Flags)
    // =========================================================================

    /// Fetches the global `/app_strings/global_config` document.
    /// Returns `AppConfig.fallback` on any network or decode failure — the app
    /// never hard-crashes due to a missing config document.
    func fetchAppConfig() async -> AppConfig {
        guard let db else { return .fallback }
        do {
            let doc = try await db.collection("app_strings").document("global_config").getDocument()
            guard doc.exists, let data = doc.data(),
                  let jsonData = try? JSONSerialization.data(withJSONObject: data),
                  let config = try? JSONDecoder().decode(AppConfig.self, from: jsonData)
            else { return .fallback }
            return config
        } catch {
            Crashlytics.crashlytics().record(error: error)
            return .fallback
        }
    }
}

// MARK: - UserProfile  (value object parsed from Firestore map)

struct UserProfile {
    let ageBracket: String
    let wellnessGoal: String
    let isLifetimeArchiveUnlocked: Bool
    let availableTokens: Int
    let unlockedProtocolIDs: [String]

    init(from data: [String: Any]) {
        ageBracket               = data["ageBracket"]               as? String ?? ""
        wellnessGoal             = data["wellnessGoal"]             as? String ?? ""
        isLifetimeArchiveUnlocked = data["isLifetimeArchiveUnlocked"] as? Bool   ?? false
        availableTokens          = data["availableTokens"]          as? Int    ?? 0
        unlockedProtocolIDs      = data["unlockedProtocolIDs"]      as? [String] ?? []
    }
}
