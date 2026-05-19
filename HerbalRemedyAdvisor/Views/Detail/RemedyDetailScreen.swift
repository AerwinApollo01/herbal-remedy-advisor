import SwiftUI

struct RemedyDetailScreen: View {
    let remedy: Remedy
    @EnvironmentObject var journalVM:     JournalViewModel
    @EnvironmentObject var userProfileVM: UserProfileViewModel
    @EnvironmentObject var appConfig:     AppConfigService
    @Environment(\.dismiss) var dismiss
    @State private var selectedIngredient: IngredientDetail?

    // MARK: - Shimmer placeholder for AsyncImage loading state
    private var shimmerPlaceholder: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.mist.opacity(0.2), Color.mist.opacity(0.4), Color.mist.opacity(0.2)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }

    var day1Quote: Quote {
        QuoteDatabase.quote(for: remedy.tid, dayNumber: 1)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: Hero card — remote image when available, SF-symbol fallback
                ZStack(alignment: .bottomLeading) {
                    // Background gradient (always rendered — shows through semi-transparent image)
                    LinearGradient(
                        colors: [Color(hex: remedy.color), Color(hex: remedy.color).opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)

                    // Remote hero image via Firebase Storage URL
                    if let rawURL = remedy.imageURL, let imageURL = URL(string: rawURL) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .clipped()
                                    .overlay(
                                        // Dark scrim so metadata text remains legible
                                        LinearGradient(
                                            colors: [.clear, Color.black.opacity(0.55)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            case .failure:
                                // Failure placeholder — gradient already visible beneath
                                Color.clear.frame(height: 200)
                            case .empty:
                                // Shimmer placeholder while loading
                                shimmerPlaceholder.frame(height: 200)
                            @unknown default:
                                Color.clear.frame(height: 200)
                            }
                        }
                    }

                    // Text overlay — always on top of image or gradient
                    VStack(alignment: .leading, spacing: 6) {
                        Image(systemName: remedy.sfSymbol)
                            .font(.system(size: 36))
                            .foregroundColor(.white.opacity(0.9))
                        Text(remedy.name)
                            .font(.notoSerif(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text(remedy.origin)
                            .font(.notoSans(size: 12))
                            .foregroundColor(.white.opacity(0.8))

                        // System priority tag from Firestore
                        if let priority = remedy.systemPriority {
                            Text(priority.uppercased())
                                .font(.notoSans(size: 8, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .kerning(1)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }

                VStack(alignment: .leading, spacing: 24) {
                    // Ingredients
                    sectionBlock(title: "Ingredients") {
                        VStack(alignment: .leading, spacing: 6) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(remedy.ingredientDetails) { detail in
                                        Button {
                                            selectedIngredient = detail
                                        } label: {
                                            HStack(spacing: 4) {
                                                Text(detail.name)
                                                    .font(.notoSans(size: 10))
                                                    .foregroundColor(.forest)
                                                Image(systemName: "info.circle")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.forest.opacity(0.5))
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.mist)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            Text("Tap any ingredient to learn more")
                                .font(.notoSans(size: 10))
                                .foregroundColor(.subtext.opacity(0.6))
                        }
                    }

                    // About
                    sectionBlock(title: "About this Remedy") {
                        Text(remedy.desc)
                            .font(.notoSans(size: 13))
                            .foregroundColor(.subtext)
                            .lineSpacing(4)
                    }

                    // Preparation Steps
                    sectionBlock(title: "Preparation Steps") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(remedy.steps.enumerated()), id: \.offset) { i, step in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(i + 1)")
                                        .font(.notoSans(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 26, height: 26)
                                        .background(Color.forest)
                                        .clipShape(Circle())
                                    Text(step)
                                        .font(.notoSans(size: 13))
                                        .foregroundColor(.subtext)
                                        .lineSpacing(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }

                    // Day 1 Wisdom
                    quoteCard

                    // Begin Journal CTA
                    Button {
                        journalVM.startJournal(remedy: remedy)
                    } label: {
                        Text("Begin \(remedy.duration)-Day Protocol")
                            .font(.notoSerif(size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.gold, .copper],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .gold.opacity(0.4), radius: 8, y: 4)
                    }
                    .accessibilityHint("Starts your protocol journal for this remedy")

                    // Per-remedy disclaimer
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 5) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.copper)
                            Text("Before You Start")
                                .font(.notoSans(size: 10, weight: .semibold))
                                .foregroundColor(.copper)
                        }
                        Text(remedy.disclaimer)
                            .font(.notoSans(size: 11))
                            .foregroundColor(.copper)
                            .lineSpacing(3)
                    }
                    .padding(12)
                    .background(Color.gold.opacity(0.08))
                    .overlay(
                        Rectangle()
                            .frame(width: 3)
                            .foregroundColor(.copper),
                        alignment: .leading
                    )
                    .cornerRadius(6)

                    // Citations
                    if !remedy.citations.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sources")
                                .font(.notoSans(size: 10, weight: .semibold))
                                .foregroundColor(.sage)
                                .kerning(0.5)
                            ForEach(Array(remedy.citations.enumerated()), id: \.offset) { i, citation in
                                Link(destination: URL(string: citation.url) ?? URL(string: "https://pubmed.ncbi.nlm.nih.gov")!) {
                                    HStack(alignment: .top, spacing: 6) {
                                        Text("\(i + 1).")
                                            .font(.notoSans(size: 10))
                                            .foregroundColor(.sage)
                                        Text(citation.text)
                                            .font(.notoSans(size: 10))
                                            .foregroundColor(.sage)
                                            .lineSpacing(2)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 9))
                                            .foregroundColor(.sage.opacity(0.6))
                                    }
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.sage.opacity(0.06))
                        .cornerRadius(8)
                    }

                    // General reference disclaimer footer — text driven by /app_strings/global_config
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 9))
                                .foregroundColor(.subtext.opacity(0.5))
                            Text("GENERAL REFERENCE")
                                .font(.notoSans(size: 9, weight: .semibold))
                                .foregroundColor(.subtext.opacity(0.5))
                                .kerning(0.5)
                        }
                        Text(appConfig.generalReferenceDisclaimer)
                            .font(.notoSans(size: 10))
                            .foregroundColor(.subtext.opacity(0.45))
                            .lineSpacing(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(Color.mist.opacity(0.08))
                    .cornerRadius(8)

                    Spacer(minLength: 40)

                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
            }
        }
        .background(Color.cream)
        // Museum gate — applied as a ZStack overlay.
        // Local catalog entries are always treated as accessible (isRemedyAccessible returns true).
        // For Firestore-sourced remedies, isRemedyAccessible checks unlockedProtocolIDs.
        .protocolLockGate(
            isLocked: BuildConfig.isTestFlightBetaBuild
                ? false
                : !userProfileVM.isRemedyAccessible(remedy),
            title:    remedy.name,
            protocolID: remedy.name
        )
        .sheet(item: $selectedIngredient) { detail in
            IngredientDetailSheet(ingredient: detail)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.notoSans(size: 13))
                    .foregroundColor(.forest)
                }
            }
        }
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                if let t = TraditionDatabase.tradition(for: remedy.tid) {
                    TraditionFlagView(tradition: t, size: 14)
                }
                Text("DAY 1 WISDOM · \(remedy.tradition.uppercased())")
                    .font(.notoSans(size: 9, weight: .semibold))
                    .foregroundColor(.sage)
                    .kerning(0.5)
            }

            Text("\u{201C}")
                .font(.notoSerif(size: 30))
                .foregroundColor(.mist)
                .padding(.bottom, -12)

            Text(day1Quote.q)
                .notoSerifItalic(size: 13)
                .foregroundColor(.forest)
                .lineSpacing(5)

            Text("— \(day1Quote.a)")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.gold)

            Text(day1Quote.c)
                .font(.notoSans(size: 10))
                .foregroundColor(.subtext)
                .lineSpacing(3)
        }
        .padding(16)
        .background(Color.forest.opacity(0.05).overlay(Color.sage.opacity(0.03)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.mist, lineWidth: 1))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func sectionBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.notoSerif(size: 16, weight: .bold))
                .foregroundColor(.forest)
            content()
        }
    }
}
