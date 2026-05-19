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

    // MARK: - Custom decoder with payload bounds enforcement

    /// Decodes a Firestore document payload and validates field sizes before accepting it.
    ///
    /// A compromised backend or MITM attack on an unprotected channel could deliver bloated
    /// or injection-laden payloads. Bounds enforcement ensures the client rejects malformed
    /// documents before they reach ViewModels or the UI rendering layer.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id                 = try c.decode(String.self,              forKey: .id)
        title              = try c.decode(String.self,              forKey: .title)
        cycleLengthDays    = try c.decode(Int.self,                 forKey: .cycleLengthDays)
        systemPriority     = try c.decode(String.self,              forKey: .systemPriority)
        historicalContext  = try c.decode(String.self,              forKey: .historicalContext)
        ingredientDetails  = try c.decode([IngredientDetail].self,  forKey: .ingredientDetails)
        citationReferences = try c.decode([String].self,            forKey: .citationReferences)
        imageURL           = try c.decodeIfPresent(String.self,     forKey: .imageURL)
        color              = try c.decodeIfPresent(String.self,     forKey: .color)
        tid                = try c.decodeIfPresent(String.self,     forKey: .tid)
        origin             = try c.decodeIfPresent(String.self,     forKey: .origin)
        isStarterVolume    = (try c.decodeIfPresent(Bool.self,      forKey: .isStarterVolume)) ?? false

        // ── Structural bounds checks ────────────────────────────────────────────
        func corrupt(_ field: String, _ reason: String) -> DecodingError {
            .dataCorrupted(.init(codingPath: c.codingPath, debugDescription: "[\(field)] \(reason)"))
        }

        guard InputSanitizer.isValidDocumentID(id) else {
            throw corrupt("id", "failed document-path safety check")
        }
        guard title.count <= InputSanitizer.maxProtocolTitleLength else {
            throw corrupt("title", "exceeds \(InputSanitizer.maxProtocolTitleLength) characters")
        }
        guard historicalContext.count <= InputSanitizer.maxHistoricalContextLength else {
            throw corrupt("historicalContext", "exceeds \(InputSanitizer.maxHistoricalContextLength) characters")
        }
        guard cycleLengthDays > 0, cycleLengthDays <= 365 else {
            throw corrupt("cycleLengthDays", "out of range 1–365: \(cycleLengthDays)")
        }
        guard !ingredientDetails.isEmpty, ingredientDetails.count <= 30 else {
            throw corrupt("ingredientDetails", "count \(ingredientDetails.count) outside bounds 1–30")
        }
        guard citationReferences.count <= 50 else {
            throw corrupt("citationReferences", "count exceeds limit of 50")
        }
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
