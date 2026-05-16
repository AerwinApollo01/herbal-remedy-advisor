import SwiftUI

struct ResultsScreen: View {
    @EnvironmentObject var symptomVM: SymptomViewModel
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var traditionVM: TraditionViewModel

    @State private var showTraditionFilter = false
    @State private var selectedRemedy: Remedy?
    @State private var navigateToDetail = false

    var displayedRemedies: [Remedy] {
        if traditionVM.selectedTraditionIds.isEmpty {
            return symptomVM.matchedRemedies
        }
        return symptomVM.matchedRemedies.filter {
            traditionVM.selectedTraditionIds.contains($0.tid)
        }
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
                                        journalVM.startJournal(remedy: remedy)
                                    }
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
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .padding(.top, 16)
            }
            .background(Color.cream)
        }
        .background(Color.cream)

        .navigationBarHidden(true)
        .sheet(isPresented: $showTraditionFilter) {
            TraditionFilterScreen(isStandaloneTab: false)
        }
        .navigationDestination(isPresented: $navigateToDetail) {
            if let remedy = selectedRemedy {
                RemedyDetailScreen(remedy: remedy)
            }
        }
    }

    private var filterRow: some View {
        HStack(spacing: 10) {
            filterChip(label: "All", active: traditionVM.selectedTraditionIds.isEmpty) {
                traditionVM.clearAll()
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
    }

    private var disclaimerFooter: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Health Disclaimer", systemImage: "exclamationmark.triangle")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.copper)
            Text("These remedies are based on traditional practices from various healing cultures. They are not intended to diagnose, treat, cure, or prevent any medical condition. Always consult a qualified, licensed healthcare provider before beginning any herbal cleanse or protocol — especially if pregnant, nursing, taking medication, or managing a health condition.")
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
}
