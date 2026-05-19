import FirebaseCrashlytics
import Foundation
import StoreKit

// MARK: - PurchaseManager

/// Manages StoreKit 2 transactions for the Nys lifetime archive unlock.
///
/// Product ID: `nys.lifetime.archive.unlock`  ($19.99 non-consumable)
///
/// Usage:
/// ```swift
/// let result = await PurchaseManager.shared.purchaseLifetimeArchive()
/// if result == .success { await userProfileVM.applyLifetimeUnlock() }
/// ```
@MainActor
final class PurchaseManager: ObservableObject {

    // MARK: - Constants

    static let lifetimeArchiveProductID = "nys.lifetime.archive.unlock"

    // MARK: - Singleton

    static let shared = PurchaseManager()
    private init() {}

    // MARK: - Published state

    @Published private(set) var product:       Product?      = nil
    @Published private(set) var isLoading:     Bool          = false
    @Published private(set) var purchaseError: String?       = nil
    @Published private(set) var isEntitled:    Bool          = false

    // MARK: - Purchase outcome

    enum PurchaseResult {
        case success
        case userCancelled
        case pending
        case failed(String)
    }

    // MARK: - JWS verification error

    /// Typed error raised when Apple's cryptographic signature check fails.
    /// Kept separate from generic `Error` so call sites can distinguish a JWS
    /// tamper event from a network or product-loading failure.
    enum JWSVerificationError: LocalizedError {
        case signatureInvalid
        case transactionRevoked(id: UInt64)

        var errorDescription: String? {
            switch self {
            case .signatureInvalid:
                return "Purchase verification failed. Please try again or contact support."
            case .transactionRevoked:
                return "This purchase has been revoked. Contact Apple Support if you believe this is an error."
            }
        }
    }

    // MARK: - Lifecycle

    /// Call once on launch to load the product metadata and verify entitlements.
    func initialize() async {
        await loadProduct()
        await verifyCurrentEntitlement()
    }

    // MARK: - Product loading

    private func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.lifetimeArchiveProductID])
            product = products.first
        } catch {
            purchaseError = "Could not load archive product: \(error.localizedDescription)"
        }
    }

    // MARK: - Purchase

    /// Initiates a StoreKit 2 purchase flow for the lifetime archive unlock.
    /// Returns a typed `PurchaseResult` — the caller is responsible for
    /// updating `UserProfileViewModel` on `.success`.
    func purchaseLifetimeArchive() async -> PurchaseResult {
        guard let product else {
            return .failed("Archive product unavailable. Check App Store connectivity.")
        }
        isLoading     = true
        purchaseError = nil
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                // Unpack and cryptographically verify the StoreKit 2 JWS payload.
                // checkVerified throws JWSVerificationError.signatureInvalid if Apple's
                // signature does not pass — we never set isEntitled on an unverified result.
                let transaction = try checkVerified(verification)

                // Guard against a valid-but-revoked transaction (refund or family revocation).
                if let revocationDate = transaction.revocationDate {
                    Crashlytics.crashlytics().log(
                        "[PurchaseManager] Transaction \(transaction.id) revoked at \(revocationDate) — access denied"
                    )
                    await transaction.finish()
                    throw JWSVerificationError.transactionRevoked(id: transaction.id)
                }

                // Finish BEFORE setting local state so the App Store knows we've
                // processed the transaction regardless of any downstream failure.
                await transaction.finish()
                isEntitled = true
                return .success

            case .userCancelled:
                return .userCancelled

            case .pending:
                return .pending

            @unknown default:
                return .failed("Unexpected StoreKit response.")
            }
        } catch {
            purchaseError = error.localizedDescription
            return .failed(error.localizedDescription)
        }
    }

    // MARK: - Restore

    /// Restores previous purchases — call from the lock gate "Restore" button.
    func restorePurchases() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            try await AppStore.sync()
            await verifyCurrentEntitlement()
            return isEntitled
        } catch {
            purchaseError = error.localizedDescription
            return false
        }
    }

    // MARK: - Entitlement verification

    /// Checks current transaction history to see if the lifetime product is already owned.
    func verifyCurrentEntitlement() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.lifetimeArchiveProductID,
               transaction.revocationDate == nil {
                isEntitled = true
                return
            }
        }
        isEntitled = false
    }

    // MARK: - Helpers

    /// Unpacks a StoreKit 2 `VerificationResult<T>` with explicit JWS validation.
    ///
    /// `.verified` — returns the payload. Access granted.
    /// `.unverified` — logs a structured anomaly event to Crashlytics (type only, no PII),
    ///                 then throws `JWSVerificationError.signatureInvalid`. Access denied.
    ///                 The raw `VerificationResult.VerificationError` is intentionally NOT
    ///                 surfaced to the UI to avoid leaking implementation details to attackers.
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let verificationError):
            // Log the error type (not its description) so we can track anomaly frequency
            // without embedding JWS internals in user-visible strings.
            let anomaly = NSError(
                domain: "NysApp.StoreKit.JWSVerification",
                code: 4001,
                userInfo: [
                    "error_type": String(describing: type(of: verificationError)),
                    NSLocalizedDescriptionKey: "JWS signature validation failed — isLifetimeArchiveUnlocked remains false",
                ]
            )
            Crashlytics.crashlytics().record(error: anomaly)
            Crashlytics.crashlytics().log("[PurchaseManager] JWS unverified — access route terminated")
            throw JWSVerificationError.signatureInvalid

        case .verified(let value):
            return value
        }
    }
}
