import SwiftUI

struct RemedyCard: View {
    let remedy: Remedy
    let onViewProtocol: () -> Void
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color(hex: remedy.color), Color(hex: remedy.color).opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                VStack(alignment: .leading, spacing: 4) {
                    Text(remedy.icon)
                        .font(.system(size: 26))
                    Text(remedy.name)
                        .font(.notoSerif(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(remedy.origin)
                        .font(.notoSans(size: 10))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
            }

            // Body
            VStack(alignment: .leading, spacing: 10) {
                // Ingredient chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(remedy.ingredients, id: \.self) { ing in
                            Text(ing)
                                .font(.notoSans(size: 10))
                                .foregroundColor(.forest)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.mist)
                                .cornerRadius(10)
                        }
                    }
                }

                Text(remedy.desc)
                    .font(.notoSans(size: 11))
                    .foregroundColor(.subtext)
                    .lineLimit(3)

                // Action row
                HStack(spacing: 8) {
                    Button(action: onViewProtocol) {
                        Text("View Protocol →")
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 9)
                            .frame(maxWidth: .infinity)
                            .background(Color.forest)
                            .cornerRadius(10)
                    }
                    .accessibilityHint("Opens the full remedy protocol")

                    Button(action: onStart) {
                        Text("📓 Start")
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 9)
                            .frame(maxWidth: .infinity)
                            .background(Color.gold)
                            .cornerRadius(10)
                    }
                    .accessibilityHint("Begins the cleanse journal for this remedy")
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.07), radius: 16, x: 0, y: 4)
    }
}
