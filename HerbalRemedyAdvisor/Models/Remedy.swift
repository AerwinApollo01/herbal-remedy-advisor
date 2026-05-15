import Foundation

struct Remedy: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let origin: String
    let tradition: String
    let tid: String
    let icon: String
    let color: String
    let ingredients: [String]
    let desc: String
    let steps: [String]
    let duration: Int

    static func == (lhs: Remedy, rhs: Remedy) -> Bool {
        lhs.name == rhs.name
    }
}
