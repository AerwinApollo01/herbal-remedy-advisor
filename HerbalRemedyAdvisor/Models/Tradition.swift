import Foundation

struct Tradition: Identifiable {
    let id: String
    let name: String
    let region: String
    let flag: String
    let sfSymbol: String
    let flagImageName: String?  // nil → show sfSymbol instead (multi-nation traditions)
    let color: String
    let desc: String
    let tags: [String]
}
