import Foundation

struct Tradition: Identifiable, Hashable {
    let id: String
    let name: String
    let region: String
    let flag: String
    let sfSymbol: String
    let flagImageName: String?
    let color: String
    let desc: String
    let tags: [String]

    static func == (lhs: Tradition, rhs: Tradition) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
