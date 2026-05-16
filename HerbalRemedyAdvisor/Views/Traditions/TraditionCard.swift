import SwiftUI

struct TraditionCard: View {
    let tradition: Tradition
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Banner
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [Color(hex: tradition.color), Color(hex: tradition.color).opacity(0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 90)

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            TraditionFlagView(tradition: tradition, size: 22)
                            Text(tradition.name)
                                .font(.notoSerif(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            Text(tradition.region)
                                .font(.notoSans(size: 10))
                                .foregroundColor(.white.opacity(0.75))
                        }
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }

                // Body
                VStack(alignment: .leading, spacing: 10) {
                    Text(tradition.desc)
                        .font(.notoSans(size: 11))
                        .foregroundColor(.subtext)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 6) {
                        ForEach(tradition.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.notoSans(size: 9, weight: .semibold))
                                .foregroundColor(Color(hex: tradition.color))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: tradition.color).opacity(0.12))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.gold : Color.clear, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.10), radius: 12, x: 0, y: 3)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tradition.name)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
