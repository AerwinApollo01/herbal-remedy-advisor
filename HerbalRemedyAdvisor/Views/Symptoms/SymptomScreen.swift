import SwiftUI

struct SymptomScreen: View {
    @EnvironmentObject var symptomVM: SymptomViewModel
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var traditionVM: TraditionViewModel
    @Binding var selectedTab: Int

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        mainContent
            .alert("Select at least one symptom", isPresented: $symptomVM.showAlert) {
                Button("OK", role: .cancel) {}
            }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            AppHeader(
                icon: "leaf.fill",
                label: "Traditional Medicine",
                title: "Nise",
                subtitle: "Eastern & Traditional Medicine"
            )

            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(symptomVM.allSymptoms, id: \.self) { symptom in
                            SymptomChip(
                                symptom: symptom,
                                isSelected: symptomVM.selectedSymptoms.contains(symptom),
                                onTap: { symptomVM.toggleSymptom(symptom) }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
                .padding(.bottom, 100)
            }
            .background(Color.cream)

            ctaButton
        }
        .background(Color.cream)

    }

    private var ctaButton: some View {
        Button {
            if symptomVM.selectedSymptoms.isEmpty {
                symptomVM.showAlert = true
            } else {
                traditionVM.clearAll()
                symptomVM.analyzeSymptoms()
                selectedTab = 1
            }
        } label: {
            Text("Find Natural Remedies")
                .font(.notoSerif(size: 16))
                .foregroundColor(.cream)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    LinearGradient(
                        colors: [.sage, .forest],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(18)
                .shadow(color: .forest.opacity(0.3), radius: 6, y: 3)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.cream)
        .accessibilityHint("Finds remedies matching your selected symptoms")
    }
}
