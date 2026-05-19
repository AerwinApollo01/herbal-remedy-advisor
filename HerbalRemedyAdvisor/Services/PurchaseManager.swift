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
                // Verify the transaction with Apple's JWS signature
                let transaction = try checkVerified(verification)
                isEntitled = true
                await transaction.finish()
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

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let value):
            return value
        }
    }
}
