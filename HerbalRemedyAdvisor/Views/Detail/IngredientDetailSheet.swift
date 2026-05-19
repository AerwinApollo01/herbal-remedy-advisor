import SwiftUI

struct IngredientDetailSheet: View {
    let ingredient: IngredientDetail
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Name header
                    Text(ingredient.name)
                        .font(.notoSerif(size: 22, weight: .bold))
                        .foregroundColor(.forest)
                        .fixedSize(horizontal: false, vertical: true)

                    // What is this
                    detailSection(icon: "info.circle.fill", label: "WHAT IS THIS?") {
                        Text(ingredient.what)
                            .font(.notoSans(size: 14))
                            .foregroundColor(.subtext)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Why it's in this remedy
                    detailSection(icon: "sparkles", label: "WHY IT'S IN THIS REMEDY") {
                        Text(ingredient.why)
                            .font(.notoSans(size: 14))
                            .foregroundColor(.subtext)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Where to source
                    detailSection(icon: "bag.fill", label: "WHERE TO SOURCE") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(ingredient.whereToBuy)
                                .font(.notoSans(size: 14))
                                .foregroundColor(.subtext)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)

                            // Partner deep-link — only rendered when present in Firestore payload
                            if let rawURL = ingredient.purchasePartnerURL,
                               let partnerURL = URL(string: rawURL) {
                                Link(destination: partnerURL) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.up.right.square.fill")
                                            .font(.system(size: 12))
                                        Text("View Verified Distributor")
                                            .font(.notoSans(size: 12, weight: .semibold))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 10))
                                            .opacity(0.5)
                                    }
                                    .foregroundColor(.sage)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(Color.sage.opacity(0.07))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.sage.opacity(0.2), lineWidth: 1)
                                    )
                                }
                                .accessibilityLabel("Open verified distributor for \(ingredient.name)")
                            }
                        }
                    }

                    // Safety notes (conditional)
                    if let safety = ingredient.safety {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.copper)
                                Text("SAFETY NOTES")
                                    .font(.notoSans(size: 10, weight: .semibold))
                                    .foregroundColor(.copper)
                                    .kerning(0.5)
                            }
                            Text(safety)
                                .font(.notoSans(size: 13))
                                .foregroundColor(.copper)
                                .lineSpacing(4)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(14)
                        .background(Color.gold.opacity(0.08))
                        .overlay(
                            Rectangle()
                                .frame(width: 3)
                                .foregroundColor(.copper),
                            alignment: .leading
                        )
                        .cornerRadius(8)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
            .background(Color.cream)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.forest.opacity(0.5))
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func detailSection<Content: View>(
        icon: String,
        label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                    .foregroundColor(.sage)
                Text(label)
                    .font(.notoSans(size: 10, weight: .semibold))
                    .foregroundColor(.sage)
                    .kerning(0.5)
            }
            content()
        }
    }
}
