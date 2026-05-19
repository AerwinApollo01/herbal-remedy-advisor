import SwiftUI

struct ResultsScreen: View {
    @EnvironmentObject var symptomVM:      SymptomViewModel
    @EnvironmentObject var journalVM:      JournalViewModel
    @EnvironmentObject var traditionVM:    TraditionViewModel
    @EnvironmentObject var userProfileVM:  UserProfileViewModel
    @Binding var selectedTab: Int

    @State private var showTraditionFilter    = false
    @State private var selectedRemedy:         Remedy?
    @State private var navigateToDetail        = false
    @State private var pendingReplaceRemedy:   Remedy?
    /// Active `systemPriority` filter chip value — nil means "All".
    @State private var activePriorityFilter:   String? = nil

    // MARK: - Derived data

    /// Distinct `systemPriority` values present in the current result set,
    /// sorted alphabetically to drive the dynamic chip row.
    var presentPriorities: [String] {
        let values = symptomVM.matchedRemedies.compactMap(\.systemPriority)
        return Array(Set(values)).sorted()
    }

    var displayedRemedies: [Remedy] {
        var base = symptomVM.matchedRemedies

        // System-priority filter (from dynamic Firestore metadata)
        if let priority = activePriorityFilter {
            base = base.filter { $0.systemPriority == priority }
        }

        // Tradition filter
        if !traditionVM.selectedTraditionIds.isEmpty {
            base = base.filter { traditionVM.selectedTraditionIds.contains($0.tid) }
        }

        return base
    }

    var presentTraditions: [String] {
        Array(Set(symptomVM.matchedRemedies.map { $0.tid }))
    }

    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                icon: "list.bullet.rectangle",
                label: "Results",
                title: "Your Remedies",
                subtitle: "Based on your symptoms"
            )

            if symptomVM.isLoading {
                skeletonList
            } else if symptomVM.matchedRemedies.isEmpty {
                noAnalysisEmptyState
            } else {
                remedyList
            }
        }
        .background(Color.cream)
        .navigationBarHidden(true)
        .sheet(isPresented: $showTraditionFilter) {
            TraditionFilterScreen(isStandaloneTab: false)
        }
        .navigationDestination(isPresented: $navigateToDetail) {
            if let remedy = selectedRemedy {
                // ProtocolDetailView: enriches with Firestore data + lock gate
                ProtocolDetailView(remedy: remedy)
            }
        }
        .confirmationDialog(replaceDialogTitle, isPresented: $pendingReplaceRemedy.isSomeBinding,
                            titleVisibility: .visible) {
            Button("Replace Protocol", role: .destructive) {
                if let remedy = pendingReplaceRemedy {
                    journalVM.startJournal(remedy: remedy)
                }
                pendingReplaceRemedy = nil
            }
            Button("Cancel", role: .cancel) { pendingReplaceRemedy = nil }
        } message: {
            if let current = journalVM.journalRecipe {
                Text("You're on Day \(journalVM.currentDayNumber) of \"\(current.name)\". Starting a new protocol will reset your progress.")
            }
        }
    }

    // MARK: - Skeleton loading state

    private var skeletonList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Consulting ancient traditions...")
                        .font(.notoSerif(size: 15))
                        .foregroundColor(.forest)
                    Text("Matching remedies to your symptoms")
                        .font(.notoSans(size: 12))
                        .foregroundColor(.subtext)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 16)

                ForEach(0..<3, id: \.self) { _ in
                    SkeletonRemedyCard()
                        .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.cream)
    }

    // MARK: - Empty state (no analysis run yet)

    private var noAnalysisEmptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "wand.and.stars")
                .font(.system(size: 56))
                .foregroundColor(.sage)
            Text("Select your symptoms first")
                .font(.notoSerif(size: 20))
                .foregroundColor(.forest)
            Text("Go to the Symptoms tab, choose what you're experiencing, and we'll find matching herbal remedies.")
                .font(.notoSans(size: 13))
                .foregroundColor(.subtext)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Button {
                selectedTab = 0
            } label: {
                Label("Go to Symptoms", systemImage: "arrow.left")
                    .font(.notoSans(size: 13, weight: .semibold))
                    .foregroundColor(.forest)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 11)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.forest, lineWidth: 1))
            }
            .accessibilityLabel("Go to Symptoms tab")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.cream)
    }

    // MARK: - Remedy list

    private var remedyList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                filterRow

                if !presentTraditions.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(presentTraditions, id: \.self) { tid in
                                if let t = TraditionDatabase.tradition(for: tid) {
                                    TraditionBadge(tradition: t.name, tid: t.id, color: t.color)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                if displayedRemedies.isEmpty {
                    Text("No remedies match the selected filters.")
                        .font(.notoSans(size: 13))
                        .foregroundColor(.subtext)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 32)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(displayedRemedies) { remedy in
                            RemedyCard(
                                remedy: remedy,
                                onViewProtocol: {
                                    selectedRemedy = remedy
                                    navigateToDetail = true
                                },
                                onStart: {
                                    if journalVM.journalRecipe != nil {
                                        pendingReplaceRemedy = remedy
                                    } else {
                                        journalVM.startJournal(remedy: remedy)
                                    }
                                },
                                isLocked: !userProfileVM.isRemedyAccessible(remedy)
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }

                disclaimerFooter
                    .padding(.horizontal, 16)

                Button {
                    symptomVM.selectedSymptoms.removeAll()
                    symptomVM.matchedRemedies.removeAll()
                } label: {
                    Text("← New Symptom Check")
                        .font(.notoSans(size: 12, weight: .semibold))
                        .foregroundColor(.forest)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.forest, lineWidth: 1))
                }
                .accessibilityLabel("Start a new symptom check")
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .padding(.top, 16)
        }
        .background(Color.cream)
    }

    // MARK: - Filter row

    private var filterRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top row: tradition filter + count
            HStack(spacing: 10) {
                filterChip(label: "All", active: traditionVM.selectedTraditionIds.isEmpty && activePriorityFilter == nil) {
                    traditionVM.clearAll()
                    activePriorityFilter = nil
                }

                filterChip(
                    label: traditionVM.selectedTraditionIds.isEmpty
                        ? "Filter by Tradition"
                        : "Tradition (\(traditionVM.selectedTraditionIds.count))",
                    active: !traditionVM.selectedTraditionIds.isEmpty
                ) {
                    showTraditionFilter = true
                }

                Spacer()

                Text("\(displayedRemedies.count) shown")
                    .font(.notoSans(size: 10))
                    .foregroundColor(.subtext)
            }

            // System-priority chips — only rendered when Firestore metadata is present
            if !presentPriorities.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Text("SYSTEM")
                            .font(.notoSans(size: 8, weight: .semibold))
                            .foregroundColor(.subtext.opacity(0.5))
                            .kerning(0.8)

                        ForEach(presentPriorities, id: \.self) { priority in
                            filterChip(
                                label: priority.capitalized,
                                active: activePriorityFilter == priority
                            ) {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    activePriorityFilter = activePriorityFilter == priority ? nil : priority
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private func filterChip(label: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(active ? .white : .forest)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(active ? Color.forest : Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.forest, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(active ? .isSelected : [])
    }

    private var disclaimerFooter: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Health Disclaimer", systemImage: "exclamationmark.triangle")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.copper)
            Text("These remedies are based on traditional practices from various healing cultures. They are not intended to diagnose, treat, cure, or prevent any medical condition. Always consult a qualified, licensed healthcare provider before beginning any herbal protocol or regimen — especially if pregnant, nursing, taking medication, or managing a health condition.")
                .font(.notoSans(size: 10))
                .foregroundColor(.copper)
                .lineSpacing(3)
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gold.opacity(0.4), lineWidth: 1)
        )
    }

    // MARK: - Helpers

    private var replaceDialogTitle: String {
        "Replace Active Protocol?"
    }
}

// Binding helper: presents a confirmationDialog only while a value is non-nil.
private extension Binding where Value == Remedy? {
    var isSomeBinding: Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue != nil },
            set: { if !$0 { self.wrappedValue = nil } }
        )
    }
}
