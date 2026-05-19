import Combine
import Foundation

// MARK: - AppConfigService

/// Observable wrapper around `AppConfig` fetched from `/app_strings/global_config`.
/// Injected into the SwiftUI environment so any view can react to remote copy changes
/// without a build. Falls back to `AppConfig.fallback` while loading or on failure.
@MainActor
final class AppConfigService: ObservableObject {

    // MARK: Published state

    @Published private(set) var config: AppConfig = .fallback
    @Published private(set) var isLoading: Bool = false

    // MARK: Lifecycle

    init() {}

    /// Triggers an async fetch from Firestore. Call once from `HerbalRemedyAdvisorApp`
    /// on launch via `.task { await appConfig.load() }`.
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        let fetched = await FirestoreService.shared.fetchAppConfig()
        config    = fetched
        isLoading = false
    }

    // MARK: Convenience accessors (proxy to AppConfig fields)

    var generalReferenceDisclaimer: String { config.generalReferenceDisclaimer }
    var shortDisclaimer:            String { config.shortDisclaimer }
    var safetyHeaderLabel:          String { config.safetyHeaderLabel }
    var archiveUnlockEnabled:       Bool   { config.archiveUnlockEnabled }
    var archiveUnlockPriceLabel:    String { config.archiveUnlockPriceLabel }
    var tokenUnlockCost:            Int    { config.tokenUnlockCost }
}
