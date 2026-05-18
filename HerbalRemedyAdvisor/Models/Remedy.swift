import Foundation

struct IngredientDetail: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let what: String
    let why: String
    let whereToBuy: String
    let safety: String?
}

struct RemedyCitation: Hashable {
    let text: String
    let url: String
}

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
