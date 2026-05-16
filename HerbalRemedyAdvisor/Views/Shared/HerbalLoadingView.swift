import SwiftUI

struct HerbalLoadingView: View {
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.5

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 56))
                .foregroundColor(.sage)
                .rotationEffect(.degrees(rotation))
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)

            Text("Consulting ancient herbal traditions...")
                .font(.notoSerif(size: 16))
                .foregroundColor(.forest)
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: opacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cream)
        .onAppear {
            rotation = 360
            opacity = 1.0
        }
    }
}
