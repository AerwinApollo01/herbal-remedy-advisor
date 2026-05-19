import SwiftUI

// MARK: - ProtocolDetailView

/// The primary protocol detail surface. Wraps `RemedyDetailScreen` content with:
///   1. A `ProtocolDetailViewModel` state machine that enriches the local Remedy
///      with live Firestore data (imageURL, systemPriority, citationReferences).
///   2. A `.loading` shimmer skeleton that renders while the remote fetch is in flight.
///   3. A `.failure` fallback banner that degrades gracefully without crashing.
///   4. The `ProtocolLockGateOverlay` applied conditionally based on
///      `UserProfileViewModel.isProtocolAccessible()`.
///
/// Navigation entry point: Replace direct `RemedyDetailScreen(remedy:)` pushes with
/// `ProtocolDetailView(remedy: remedy)` to get remote enrichment + lock gating.
struct ProtocolDetailView: View {

    // MARK: - Input

    let remedy: Remedy

    // MARK: - ViewModel (owned by this view)

    @StateObject private var viewModel: ProtocolDetailViewModel

    // MARK: - Environment

    @EnvironmentObject private var journalVM:     JournalViewModel
    @EnvironmentObject private var userProfileVM: UserProfileViewModel
    @EnvironmentObject private var appConfig:     AppConfigService
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    // MARK: - Local state

    @State private var selectedIngredient: IngredientDetail?

    // MARK: - Init

    init(remedy: Remedy, protocolID: String? = nil) {
        self.remedy = remedy
        // StateObject initializer — wraps the VM so SwiftUI owns the lifecycle
        _viewModel = StateObject(
            wrappedValue: ProtocolDetailViewModel(
                remedy:     remedy,
                protocolID: protocolID
            )
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            // Primary content — switches on fetch state
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    contentSection
                }
            }
            .background(Color.cream)

            // Remote-fetch error banner — floats above scroll, fades after 4s
            if case .failure(let err) = viewModel.fetchState {
                errorBanner(message: err.errorDescription ?? "Unable to load archive data.")
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        // Lock gate overlay — applied at the ZStack level, covers entire screen
        .protocolLockGate(
            isLocked: lockGateActive,
            title:    viewModel.displayTitle,
            protocolID: remedy.name  // Use Firestore ID when available
        )
        .sheet(item: $selectedIngredient) { detail in
            IngredientDetailSheet(ingredient: detail)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar { backButton }
        .task { await viewModel.fetchRemote() }
        .animation(.easeInOut(duration: 0.3), value: lockGateActive)
    }

    // MARK: - Lock gate condition
    //
    // Lock is active when ALL three conditions are true:
    //   1. User has NOT purchased lifetime archive
    //   2. This is not a starter volume (isStarterVolume == false in Firestore metadata)
    //   3. The protocol ID is absent from the user's unlockedProtocolIDs set
    //
    // While Firestore data is still loading, we conservatively treat the protocol
    // as accessible (isLoading grace period) to avoid flashing the gate on launch.
    //
    // BuildConfig.isTestFlightBetaBuild short-circuits the entire gate so every
    // tester can access all archives. Flip the flag to false to restore standard gating.
    private var lockGateActive: Bool {
        if BuildConfig.isTestFlightBetaBuild     { return false }
        if userProfileVM.isLifetimeArchiveUnlocked { return false }
        if case .loading = viewModel.fetchState  { return false }
        if case .success(let proto) = viewModel.fetchState {
            return !userProfileVM.isProtocolAccessible(proto)
        }
        return false
    }

    // MARK: - Hero section

    @ViewBuilder
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Gradient base — always rendered beneath the remote image
            LinearGradient(
                colors: [Color(hex: remedy.color), Color(hex: remedy.color).opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)

            // AsyncImage — remote URL from ProtocolDetailViewModel derived property
            if let rawURL = viewModel.displayImageURL, let url = URL(string: rawURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        img
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    colors: [.clear, Color.black.opacity(0.55)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    case .failure:
                        // Nil placeholder — gradient already visible
                        Color.clear.frame(height: 200)
                    case .empty:
                        shimmerBar.frame(height: 200)
                    @unknown default:
                        Color.clear.frame(height: 200)
                    }
                }
            }

            // Text overlay
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: remedy.sfSymbol)
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.9))

                Text(viewModel.displayTitle)
                    .font(.notoSerif(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text(remedy.origin)
                    .font(.notoSans(size: 12))
                    .foregroundColor(.white.opacity(0.8))

                // systemPriority badge — rendered only when remote data provides it
                if let priority = viewModel.displaySystemPriority {
                    Text(priority.uppercased())
                        .font(.notoSans(size: 8, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .kerning(1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(8)
                }

                // Remote-enrichment indicator (subtle, fades away when loaded)
                if case .loading = viewModel.fetchState {
                    HStack(spacing: 5) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(0.5)
                            .tint(.white.opacity(0.6))
                        Text("Loading archive data…")
                            .font(.notoSans(size: 9))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Content section

    @ViewBuilder
    private var contentSection: some View {
        switch viewModel.fetchState {
        case .idle, .loading:
            shimmerContentSkeleton

        case .success(let proto):
            remoteContent(proto: proto)

        case .failure:
            // Degrade gracefully to local fallback data — the error banner handles messaging
            localFallbackContent
        }
    }

    // MARK: - Shimmer skeleton (.loading state)

    private var shimmerContentSkeleton: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Ingredient chips shimmer
            sectionBlock(title: "Ingredients") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            shimmerBar
                                .frame(width: CGFloat.random(in: 60...100), height: 28)
                                .cornerRadius(12)
                        }
                    }
                }
            }

            // Body text shimmer
            sectionBlock(title: "About this Remedy") {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<4, id: \.self) { i in
                        shimmerBar
                            .frame(maxWidth: i == 3 ? 160 : .infinity)
                            .frame(height: 14)
                            .cornerRadius(6)
                    }
                }
            }

            // Steps shimmer
            sectionBlock(title: "Preparation Steps") {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        HStack(alignment: .top, spacing: 12) {
                            shimmerBar
                                .frame(width: 26, height: 26)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 6) {
                                shimmerBar.frame(maxWidth: .infinity).frame(height: 13).cornerRadius(5)
                                shimmerBar.frame(width: 200).frame(height: 13).cornerRadius(5)
                            }
                        }
                    }
                }
            }

            // CTA shimmer
            shimmerBar
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .cornerRadius(16)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 40)
    }

    // MARK: - Beta access banner

    /// Shown at the top of every protocol when `isTestFlightBetaBuild` is active.
    /// Uses muted cream-and-sage tracking typography so it reads as an informational
    /// accent rather than UI chrome. Completely invisible in production builds.
    @ViewBuilder
    private var betaAccessBanner: some View {
        if BuildConfig.isTestFlightBetaBuild {
            Text("── Beta Flight Access Active — All Archives Unlocked ──")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.sage.opacity(0.7))
                .kerning(0.4)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(Color.sage.opacity(0.07))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.sage.opacity(0.18)),
                    alignment: .bottom
                )
        }
    }

    // MARK: - Remote-enriched content (.success state)

    @ViewBuilder
    private func remoteContent(proto: NysProtocol) -> some View {
        VStack(alignment: .leading, spacing: 24) {

            betaAccessBanner

            // Ingredients
            sectionBlock(title: "Ingredients") {
                ingredientChips(for: proto.ingredientDetails)
            }

            // Historical context (replaces local desc)
            sectionBlock(title: "Historical Context") {
                Text(proto.historicalContext)
                    .font(.notoSans(size: 13))
                    .foregroundColor(.subtext)
                    .lineSpacing(4)
            }

            // Preparation steps (from local Remedy — not yet in Firestore schema)
            if !remedy.steps.isEmpty {
                sectionBlock(title: "Preparation Steps") {
                    prepSteps(remedy.steps)
                }
            }

            // Tradition quote card
            quoteCard

            // CTA
            ctaButton(cycleDays: proto.cycleLengthDays)

            // Disclaimer
            if !remedy.disclaimer.isEmpty {
                disclaimerBlock(remedy.disclaimer)
            }

            // Citation references from Firestore
            if !proto.citationReferences.isEmpty {
                citationsBlock(proto.citationReferences)
            }

            // General reference footer from AppConfig
            generalReferenceFooter

            Spacer(minLength: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    // MARK: - Local fallback content (.failure state)

    private var localFallbackContent: some View {
        VStack(alignment: .leading, spacing: 24) {

            betaAccessBanner

            sectionBlock(title: "Ingredients") {
                ingredientChips(for: remedy.ingredientDetails)
            }

            sectionBlock(title: "About this Remedy") {
                Text(remedy.desc)
                    .font(.notoSans(size: 13))
                    .foregroundColor(.subtext)
                    .lineSpacing(4)
            }

            if !remedy.steps.isEmpty {
                sectionBlock(title: "Preparation Steps") {
                    prepSteps(remedy.steps)
                }
            }

            quoteCard

            ctaButton(cycleDays: remedy.duration)

            if !remedy.disclaimer.isEmpty {
                disclaimerBlock(remedy.disclaimer)
            }

            if !remedy.citations.isEmpty {
                citationsBlock(remedy.citations.map(\.text))
            }

            generalReferenceFooter

            Spacer(minLength: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    // MARK: - Reusable sub-components

    @ViewBuilder
    private func ingredientChips(for details: [IngredientDetail]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(details) { detail in
                        Button { selectedIngredient = detail } label: {
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

    @ViewBuilder
    private func prepSteps(_ steps: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(steps.enumerated()), id: \.offset) { i, step in
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

    private func ctaButton(cycleDays: Int) -> some View {
        Button { journalVM.startJournal(remedy: remedy) } label: {
            Text("Begin \(cycleDays)-Day Protocol")
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
    }

    private func disclaimerBlock(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.copper)
                Text("Before You Start")
                    .font(.notoSans(size: 10, weight: .semibold))
                    .foregroundColor(.copper)
            }
            Text(text)
                .font(.notoSans(size: 11))
                .foregroundColor(.copper)
                .lineSpacing(3)
        }
        .padding(12)
        .background(Color.gold.opacity(0.08))
        .overlay(Rectangle().frame(width: 3).foregroundColor(.copper), alignment: .leading)
        .cornerRadius(6)
    }

    @ViewBuilder
    private func citationsBlock(_ refs: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sources")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.sage)
                .kerning(0.5)
            ForEach(Array(refs.enumerated()), id: \.offset) { i, ref in
                HStack(alignment: .top, spacing: 6) {
                    Text("\(i + 1).")
                        .font(.notoSans(size: 10))
                        .foregroundColor(.sage)
                    Text(ref)
                        .font(.notoSans(size: 10))
                        .foregroundColor(.sage)
                        .lineSpacing(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(12)
        .background(Color.sage.opacity(0.06))
        .cornerRadius(8)
    }

    private var generalReferenceFooter: some View {
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
    }

    private var quoteCard: some View {
        let quote = QuoteDatabase.quote(for: remedy.tid, dayNumber: 1)
        return VStack(alignment: .leading, spacing: 10) {
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
            Text(quote.q)
                .notoSerifItalic(size: 13)
                .foregroundColor(.forest)
                .lineSpacing(5)
            Text("— \(quote.a)")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.gold)
            Text(quote.c)
                .font(.notoSans(size: 10))
                .foregroundColor(.subtext)
                .lineSpacing(3)
        }
        .padding(16)
        .background(Color.forest.opacity(0.05).overlay(Color.sage.opacity(0.03)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.mist, lineWidth: 1))
        .cornerRadius(12)
    }

    // MARK: - Error banner

    private func errorBanner(message: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 13))
                .foregroundColor(.gold)
            VStack(alignment: .leading, spacing: 2) {
                Text("Archive Unavailable")
                    .font(.notoSans(size: 11, weight: .semibold))
                    .foregroundColor(.cream)
                Text(message)
                    .font(.notoSans(size: 10))
                    .foregroundColor(.mist.opacity(0.8))
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.forest.opacity(0.92))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Shimmer utility

    private var shimmerBar: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.mist.opacity(0.25),
                        Color.mist.opacity(0.45),
                        Color.mist.opacity(0.25),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var backButton: some ToolbarContent {
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

    // MARK: - Section block helper

    @ViewBuilder
    private func sectionBlock<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.notoSerif(size: 16, weight: .bold))
                .foregroundColor(.forest)
            content()
        }
    }
}
