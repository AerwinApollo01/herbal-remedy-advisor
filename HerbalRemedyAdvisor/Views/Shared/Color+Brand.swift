import SwiftUI

extension Color {
    static let forest  = Color(hex: "#1A2E1A")
    static let moss    = Color(hex: "#2D4A2D")
    static let sage    = Color(hex: "#5C7A4E")
    static let fern    = Color(hex: "#8AAB6E")
    static let mist    = Color(hex: "#C8DDB8")
    static let cream   = Color(hex: "#F5F0E8")
    static let gold    = Color(hex: "#C8A050")
    static let copper  = Color(hex: "#A0704A")
    static let subtext = Color(hex: "#4A5A3A")

    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
