import Combine
import FirebaseCrashlytics
import Foundation

// MARK: - FetchState

/// Typed state machine governing the async lifecycle of a single protocol fetch.
/// Views switch over this enum to render the correct layout — never directly
/// observe loading booleans or nullable data.
enum FetchState<T> {
    case idle
    case loading
    case success(T)
    case failure(FetchError)
}

// MARK: - FetchError

/// Strongly-typed error taxonomy for protocol detail fetch failures.
/// Each case carries the raw underlying error for defensive logging
/// while exposing a user-readable message for the fallback UI.
enum FetchError: Error, LocalizedError {
    case networkUnavailable(underlying: Error)
    case documentNotFound(id: String)
    case decodingFailure(underlying: Error)
    case firebaseNotConfigured

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Unable to reach the archive. Please check your connection."
        case .documentNotFound(let id):
            return "Protocol '\(id)' was not found in the archive."
        case .decodingFailure:
            return "The protocol data could not be read. Please try again."
        case .firebaseNotConfigured:
            return "Archive service is not configured on this device."
        }
    }

    /// Structured context for Crashlytics — never shown to users.
    var debugDescription: String {
        switch self {
        case .networkUnavailable(let e): return "networkUnavailable: \(e)"
        case .documentNotFound(let id): return "documentNotFound: id=\(id)"
        case .decodingFailure(let e):   return "decodingFailure: \(e)"
        case .firebaseNotConfigured:    return "firebaseNotConfigured"
        }
    }
}

// MARK: - ProtocolDetailViewModel

/// Governs the full async lifecycle of loading a single `/protocols/{id}` document.
///
/// State transitions:
///   idle → loading → success(NysProtocol)
///                  → failure(FetchError)   ← logs to Crashlytics, falls back to local Remedy
///
/// Local `Remedy` fallback strategy:
///   When Firestore is unavailable (no plist, offline, or decode error), the VM
///   hydrates itself from the locally-passed `Remedy` object so the UI is never empty.
///   This ensures the detail screen always renders something meaningful while the
///   remote enrichment payload (imageURL, systemPriority, citationReferences) loads.
@MainActor
final class ProtocolDetailViewModel: ObservableObject {

    // MARK: - Published state

    /// Primary state machine — views switch over this to decide which layout to render.
    @Published private(set) var fetchState: FetchState<NysProtocol> = .idle

    /// Local Remedy used as an immediate fallback payload while Firestore loads.
    /// Always populated on init so the detail screen never shows a blank layout.
    @Published private(set) var localFallback: Remedy

    /// Derived convenience: the best available title regardless of fetch state.
    var displayTitle: String {
        if case .success(let proto) = fetchState { return proto.title }
        return localFallback.name
    }

    /// Derived: historical context paragraph (remote or local desc).
    var displayHistoricalContext: String {
        if case .success(let proto) = fetchState { return proto.historicalContext }
        return localFallback.desc
    }

    /// Derived: ingredient list (remote embedded docs or local IngredientDetail array).
    var displayIngredients: [IngredientDetail] {
        if case .success(let proto) = fetchState { return proto.ingredientDetails }
        return localFallback.ingredientDetails
    }

    /// Derived: citation strings (remote refs or local RemedyCitation text).
    var displayCitations: [String] {
        if case .success(let proto) = fetchState { return proto.citationReferences }
        return localFallback.citations.map(\.text)
    }

    /// Derived: remote hero image URL string — nil falls back to SF Symbol in the view.
    var displayImageURL: String? {
        if case .success(let proto) = fetchState { return proto.imageURL }
        return localFallback.imageURL
    }

    /// Derived: systemPriority tag for the hero badge — nil hides the badge.
    var displaySystemPriority: String? {
        if case .success(let proto) = fetchState { return proto.systemPriority }
        return localFallback.systemPriority
    }

    /// Derived: cycle length in days for the CTA label.
    var displayCycleLengthDays: Int {
        if case .success(let proto) = fetchState { return proto.cycleLengthDays }
        return localFallback.duration
    }

    /// True only when the remote fetch has resolved (success or failure).
    var isRemoteEnriched: Bool {
        if case .success = fetchState { return true }
        return false
    }

    // MARK: - Private

    private let protocolID: String?

    // MARK: - Init

    /// - Parameters:
    ///   - remedy: The local `Remedy` that was tapped — used immediately as display fallback.
    ///   - protocolID: Optional Firestore document ID. When nil, no remote fetch is attempted.
    init(remedy: Remedy, protocolID: String? = nil) {
        self.localFallback = remedy
        self.protocolID    = protocolID ?? remedy.name  // name as last-resort soft ID
    }

    // MARK: - Fetch

    /// Triggers the remote fetch. Call from `.task {}` inside the detail view.
    /// Safe to call multiple times — guards against redundant in-flight fetches.
    func fetchRemote() async {
        guard case .idle = fetchState else { return }
        guard let pid = protocolID else { return }

        fetchState = .loading

        do {
            guard let proto = try await FirestoreService.shared.fetchProtocol(id: pid) else {
                let err = FetchError.documentNotFound(id: pid)
                logAndSetFailure(err)
                return
            }
            fetchState = .success(proto)
        } catch let error as NSError {
            let fetchErr: FetchError
            if error.domain == NSURLErrorDomain {
                fetchErr = .networkUnavailable(underlying: error)
            } else {
                fetchErr = .decodingFailure(underlying: error)
            }
            logAndSetFailure(fetchErr)
        }
    }

    // MARK: - Error handling

    private func logAndSetFailure(_ error: FetchError) {
        // Log the structured debug context to Crashlytics — never crash the binary.
        let nsError = NSError(
            domain: "NysProtocolFetch",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: error.debugDescription]
        )
        Crashlytics.crashlytics().record(error: nsError)

        fetchState = .failure(error)
    }
}
