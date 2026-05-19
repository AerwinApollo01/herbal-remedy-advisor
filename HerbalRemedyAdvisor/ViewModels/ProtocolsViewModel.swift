import Combine
import FirebaseCrashlytics
import Foundation

// MARK: - ProtocolsViewModel

/// Owns the full `/protocols/` collection feed.
///
/// Fetch strategy (layered fallback):
///   1. Attempt Firestore fetch — populates `remoteProtocols` on success.
///   2. On any Firestore failure (offline, plist missing, decode error) — fall back to
///      the local `RemedyDatabase` catalog so the UI is never empty.
///   3. Both sources are merged into `displayProtocols` — remote always wins when present.
///
/// Filter state:
///   `activeSystemPriority` is set by tapping a chip in the Results/Home screens.
///   The chip labels come directly from the `systemPriority` strings returned by
///   Firestore — no client-side enum mapping or hardcoded categories.
@MainActor
final class ProtocolsViewModel: ObservableObject {

    // MARK: - Published state

    /// Raw remote protocols fetched from Firestore `/protocols/` collection.
    @Published private(set) var remoteProtocols: [NysProtocol] = []

    /// Active `systemPriority` filter — nil means "show all".
    /// Set this by tapping a chip; clear it by tapping "All".
    @Published var activeSystemPriority: String? = nil

    /// Async fetch lifecycle.
    @Published private(set) var fetchState: FetchState<[NysProtocol]> = .idle

    /// Error message for the optional inline banner — nil when no active error.
    @Published private(set) var bannerError: String? = nil

    // MARK: - Derived

    /// All unique `systemPriority` values present in remote protocols, sorted
    /// alphabetically. Drives the chip row — these are live Firestore metadata strings.
    var availablePriorityChips: [String] {
        let values = remoteProtocols.compactMap { $0.systemPriority }
        return Array(Set(values)).sorted()
    }

    /// Protocols filtered by the active chip, or all if none is selected.
    var filteredRemoteProtocols: [NysProtocol] {
        guard let priority = activeSystemPriority else { return remoteProtocols }
        return remoteProtocols.filter { $0.systemPriority == priority }
    }

    /// Local-catalog Remedy objects filtered to match `activeSystemPriority`
    /// (via `Remedy.systemPriority`). Used as the fallback display when Firestore
    /// is unavailable or still loading.
    var filteredLocalRemedies: [Remedy] {
        let all = RemedyDatabase.all
        guard let priority = activeSystemPriority else { return all }
        return all.filter { $0.systemPriority == priority }
    }

    /// Whether the app is currently using remote data (true) or local fallback (false).
    var isUsingRemoteData: Bool {
        if case .success = fetchState { return true }
        return false
    }

    // MARK: - Symptom-based filtering

    /// The symptom-matched subset of `remoteProtocols`.
    /// Populated by `filterBySymptoms(_:)` after the collection is loaded.
    @Published private(set) var symptomMatchedProtocols: [NysProtocol] = []

    // MARK: - Fetch

    /// Loads the full `/protocols/` collection from Firestore.
    /// Safe to call from `.task {}` — guards against redundant concurrent fetches.
    func fetchAll() async {
        guard case .idle = fetchState else { return }
        fetchState  = .loading
        bannerError = nil

        do {
            let protocols = try await FirestoreService.shared.fetchProtocols()
            remoteProtocols = protocols
            fetchState = .success(protocols)
        } catch {
            let fetchErr = FetchError.networkUnavailable(underlying: error)
            recordError(fetchErr)
            fetchState  = .failure(fetchErr)
            bannerError = fetchErr.errorDescription
            // Fall through — `filteredLocalRemedies` provides content automatically
        }
    }

    /// Re-fetches the collection, resetting fetch state first.
    /// Useful for pull-to-refresh gestures.
    func refresh() async {
        fetchState  = .idle
        bannerError = nil
        await fetchAll()
    }

    // MARK: - Symptom matching

    /// Filters loaded remote protocols against a set of symptom strings.
    /// Matches are determined by checking if any ingredient `why` or protocol
    /// `historicalContext` field contains a symptom keyword (case-insensitive).
    /// This is a client-side heuristic — a full-text Algolia or Firestore compound
    /// query can replace this once server-side indexing is configured.
    func filterBySymptoms(_ symptoms: Set<String>) {
        guard !symptoms.isEmpty else {
            symptomMatchedProtocols = remoteProtocols
            return
        }
        symptomMatchedProtocols = remoteProtocols.filter { proto in
            symptoms.contains { symptom in
                let lower = symptom.lowercased()
                let inContext = proto.historicalContext.lowercased().contains(lower)
                let inPriority = proto.systemPriority.lowercased().contains(lower)
                let inIngredients = proto.ingredientDetails.contains {
                    $0.why.lowercased().contains(lower) || $0.what.lowercased().contains(lower)
                }
                return inContext || inPriority || inIngredients
            }
        }
    }

    // MARK: - Priority chip actions

    /// Selects or deselects a priority chip — toggling acts like a radio button.
    func togglePriorityFilter(_ priority: String) {
        withAnimation(.easeInOut(duration: 0.15)) {
            activeSystemPriority = (activeSystemPriority == priority) ? nil : priority
        }
    }

    func clearAllFilters() {
        withAnimation(.easeInOut(duration: 0.15)) {
            activeSystemPriority = nil
        }
    }

    // MARK: - Private

    private func recordError(_ error: FetchError) {
        let nsError = NSError(
            domain: "NysProtocolsFetch",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: error.debugDescription]
        )
        Crashlytics.crashlytics().record(error: nsError)
    }
}
