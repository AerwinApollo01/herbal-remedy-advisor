import Foundation

// MARK: - NysProtocol

/// Codable document schema mapping 1:1 to a Firestore `/protocols/{id}` document.
/// Uses the Embedded Document Pattern — `ingredientDetails` is stored as an array
/// of sub-maps within the document, enabling a single-network read for all protocol data.
struct NysProtocol: Identifiable, Codable, Equatable {

    // MARK: - Fields

    /// Firestore document ID (injected post-fetch via `documentID`).
    var id: String

    /// Human-readable protocol title (e.g. "Triphala & Ginger Decoction").
    let title: String

    /// Total cycle length in days (e.g. 21, 14, 7).
    let cycleLengthDays: Int

    /// Semantic body-system tag driving dynamic client-side sort chips.
    /// Examples: "digestive", "immune", "neuro", "sleep", "joint", "skin", "energy".
    let systemPriority: String

    /// Academic / archival description of the cultural origin and historical context.
    let historicalContext: String

    /// Embedded ingredient sub-documents — single read, no sub-collection join needed.
    let ingredientDetails: [IngredientDetail]

    /// Array of academic citation strings (may include DOIs, book references, etc.).
    let citationReferences: [String]

    // MARK: - Optional enrichment fields

    /// Firebase Storage path or fully-qualified HTTPS URL for the protocol hero image.
    let imageURL: String?

    /// Color hex string (e.g. "#B03020") for the protocol's tradition accent.
    let color: String?

    /// Tradition identifier (e.g. "ayurveda", "tcm", "european").
    let tid: String?

    /// Geographic and cultural origin label (e.g. "Ayurvedic Medicine · India").
    let origin: String?

    /// Whether this protocol is freely accessible (starter volume) or gated.
    let isStarterVolume: Bool

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cycleLengthDays
        case systemPriority
        case historicalContext
        case ingredientDetails
        case citationReferences
        case imageURL
        case color
        case tid
        case origin
        case isStarterVolume
    }

    // MARK: - Equatable

    static func == (lhs: NysProtocol, rhs: NysProtocol) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - NysProtocol + Local Remedy Bridge

extension NysProtocol {
    /// Converts a server-fetched `NysProtocol` into a local `Remedy` for use
    /// with the existing ViewModels while the full migration completes.
    func asRemedy() -> Remedy {
        Remedy(
            name:              title,
            origin:            origin ?? "",
            tradition:         tid?.capitalized ?? "",
            tid:               tid ?? "",
            icon:              "🌿",
            color:             color ?? "#5C7A4E",
            ingredientDetails: ingredientDetails,
            desc:              historicalContext,
            steps:             [],           // Steps fetched separately or embedded in sub-fields
            duration:          cycleLengthDays,
            disclaimer:        "",
            citations:         citationReferences.map { RemedyCitation(text: $0, url: "") },
            imageURL:          imageURL,
            systemPriority:    systemPriority
        )
    }
}

// MARK: - AppConfig

/// Codable document schema for `/app_strings/global_config` in Firestore.
/// Drives dynamic disclaimer copy, legal text, and feature flags without an app update.
struct AppConfig: Codable {

    /// Full-length general reference disclaimer shown in protocol detail views.
    let generalReferenceDisclaimer: String

    /// Short disclaimer shown in results and card contexts.
    let shortDisclaimer: String

    /// Safety section header text shown in ingredient detail sheets.
    let safetyHeaderLabel: String

    /// Dynamic feature flag: whether the Museum (archive) unlock UI is shown.
    let archiveUnlockEnabled: Bool

    /// Price display string for the lifetime archive unlock (display only, not StoreKit).
    let archiveUnlockPriceLabel: String

    /// Token spend amount for a single protocol unlock (default 1).
    let tokenUnlockCost: Int

    /// App version string from server — can be used to prompt update banners.
    let minimumSupportedVersion: String?

    // MARK: - Defaults (used when Firestore fetch fails or is pending)

    static var fallback: AppConfig {
        AppConfig(
            generalReferenceDisclaimer: "The sources and preparation methods documented here are provided for educational and cultural archival purposes only. They do not constitute medical advice, diagnosis, or treatment. Always consult a qualified healthcare provider before beginning any herbal protocol or regimen.",
            shortDisclaimer: "Traditional practices documented for educational reference. Not medical advice.",
            safetyHeaderLabel: "SAFETY NOTES",
            archiveUnlockEnabled: true,
            archiveUnlockPriceLabel: "$19.99",
            tokenUnlockCost: 1,
            minimumSupportedVersion: nil
        )
    }
}
