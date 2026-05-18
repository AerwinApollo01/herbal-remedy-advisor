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
                        Text(ingredient.whereToBuy)
                            .font(.notoSans(size: 14))
                            .foregroundColor(.subtext)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
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
