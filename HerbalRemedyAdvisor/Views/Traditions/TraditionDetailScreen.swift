import SwiftUI

struct TraditionDetailScreen: View {
    let tradition: Tradition
    @EnvironmentObject var journalVM: JournalViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedRemedy: Remedy?
    @State private var navigateToDetail = false

    var remedies: [Remedy] {
        RemedyDatabase.remedies(for: tradition.id)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    if remedies.isEmpty {
                        Text("No remedies found for this tradition.")
                            .font(.notoSans(size: 13))
                            .foregroundColor(.subtext)
                            .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(remedies) { remedy in
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
                    Spacer(minLength: 32)
                }
                .padding(.top, 16)
            }
            .background(Color.cream)
        }
        .background(Color.cream)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToDetail) {
            if let remedy = selectedRemedy {
                RemedyDetailScreen(remedy: remedy)
            }
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color(hex: tradition.color), Color(hex: tradition.color).opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Traditions")
                            .font(.notoSans(size: 13))
                    }
                    .foregroundColor(.white.opacity(0.85))
                }
                .padding(.bottom, 4)

                HStack(spacing: 12) {
                    TraditionFlagView(tradition: tradition, size: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(tradition.name)
                            .font(.notoSerif(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text(tradition.region)
                            .font(.notoSans(size: 11))
                            .foregroundColor(.white.opacity(0.75))
                    }
                }

                Text("\(remedies.count) \(remedies.count == 1 ? "remedy" : "remedies")")
                    .font(.notoSans(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .textCase(.uppercase)
                    .kerning(0.5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
    }
}
