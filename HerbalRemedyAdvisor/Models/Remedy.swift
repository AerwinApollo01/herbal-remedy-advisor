import Foundation

// MARK: - IngredientDetail

/// A single ingredient inside a protocol — embeddable in both local Remedy objects
/// and Codable NysProtocol documents fetched from Firestore.
struct IngredientDetail: Identifiable, Hashable, Codable {
    var id: String { name }
    let name: String
    let what: String
    let why: String
    let whereToBuy: String
    let safety: String?
    /// Optional affiliate / partner deep-link URL served from Firestore.
    /// Nil when no partner relationship exists for this ingredient.
    let purchasePartnerURL: String?

    init(
        name: String,
        what: String,
        why: String,
        whereToBuy: String,
        safety: String? = nil,
        purchasePartnerURL: String? = nil
    ) {
        self.name               = name
        self.what               = what
        self.why                = why
        self.whereToBuy         = whereToBuy
        self.safety             = safety
        self.purchasePartnerURL = purchasePartnerURL
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case name, what, why, whereToBuy, safety, purchasePartnerURL
    }
}

// MARK: - RemedyCitation

struct RemedyCitation: Hashable, Codable {
    let text: String
    let url: String
}

// MARK: - Remedy  (local hardcoded catalog)

/// The local-first data model powering the client catalog.
/// Server-side Firestore documents use `NysProtocol` (fully Codable).
struct Remedy: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let origin: String
    let tradition: String
    let tid: String
    let icon: String
    let color: String
    let ingredientDetails: [IngredientDetail]
    let desc: String
    let steps: [String]
    let duration: Int
    let disclaimer: String
    let citations: [RemedyCitation]

    /// Remote Firebase Storage image URL — nil falls back to the SF Symbol hero.
    var imageURL: String? = nil

    /// Dynamic system-body priority tag ("digestive", "immune", "neuro", etc.)
    /// Populated from the Firestore `/protocols/{id}` payload when available;
    /// falls back to tradition-based inference for local catalog entries.
    var systemPriority: String? = nil

    var ingredients: [String] { ingredientDetails.map(\.name) }

    var sfSymbol: String {
        switch icon {
        case "🌿": return "leaf.fill"
        case "🥛": return "cup.and.saucer.fill"
        case "🍃": return "leaf.fill"
        case "🫚": return "drop.fill"
        case "🌱": return "leaf"
        case "🫖": return "cup.and.saucer.fill"
        case "🧠": return "brain.head.profile"
        case "🌸": return "sparkles"
        case "🍈": return "circle.fill"
        case "🧄": return "leaf.circle.fill"
        case "🌰": return "circle.fill"
        case "🌙": return "moon.fill"
        default:   return "leaf.fill"
        }
    }

    static func == (lhs: Remedy, rhs: Remedy) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
