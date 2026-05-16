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
        } else {
            Image(systemName: tradition.sfSymbol)
                .font(.system(size: size * 0.8))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}
