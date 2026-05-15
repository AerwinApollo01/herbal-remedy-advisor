import SwiftUI

struct AppHeader: View {
    let icon: String
    let label: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.fern)
                Text(label)
                    .font(.notoSans(size: 10, weight: .semibold))
                    .foregroundColor(.fern)
                    .kerning(0.2)
                    .textCase(.uppercase)
            }

            Text(title)
                .font(.notoSerif(size: 17))
                .foregroundColor(.cream)

            Text(subtitle)
                .font(.notoSans(size: 11))
                .foregroundColor(.mist.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(
            ZStack {
                LinearGradient(
                    colors: [.forest, .moss],
                    startPoint: .init(x: 0, y: 0),
                    endPoint: .init(x: 1, y: 1)
                )
                RadialGradient(
                    colors: [Color.fern.opacity(0.2), .clear],
                    center: .topTrailing,
                    startRadius: 0,
                    endRadius: 80
                )
            }
            .ignoresSafeArea(edges: .top)
        )
    }
}
