import SwiftUI

struct TraditionFlagView: View {
    let tradition: Tradition
    let size: CGFloat

    var body: some View {
        if let imageName = tradition.flagImageName,
           let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: size * 1.4, height: size)
                .cornerRadius(3)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
        } else if tradition.id == "african" {
            PanAfricanFlag(width: size * 1.4, height: size)
        } else {
            Image(systemName: tradition.sfSymbol)
                .font(.system(size: size * 0.8))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

// Pan-African flag: equal horizontal stripes of red, black, green
private struct PanAfricanFlag: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            Color(red: 0.80, green: 0.10, blue: 0.10) // red
            Color.black
            Color(red: 0.07, green: 0.53, blue: 0.07) // green
        }
        .frame(width: width, height: height)
        .cornerRadius(3)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
    }
}
