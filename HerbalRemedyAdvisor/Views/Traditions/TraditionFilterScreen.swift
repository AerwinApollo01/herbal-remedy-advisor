import SwiftUI

struct TraditionFilterScreen: View {
    @EnvironmentObject var traditionVM: TraditionViewModel
    @Environment(\.dismiss) var dismiss
    let isStandaloneTab: Bool

    var body: some View {
        VStack(spacing: 0) {
            AppHeader(
                icon: "🌍",
                label: "Cultures",
                title: "Healing Traditions",
                subtitle: "Explore global wisdom"
            )

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(traditionVM.traditions) { tradition in
                        TraditionCard(
                            tradition: tradition,
                            isSelected: traditionVM.isSelected(tradition),
                            onTap: { traditionVM.toggle(tradition) }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, isStandaloneTab ? 24 : 100)
            }
            .background(Color.cream)

            if !isStandaloneTab {
                applyButton
            }
        }
        .background(Color.cream)

    }

    private var applyButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Text("Apply Filter")
                    .font(.notoSerif(size: 14))
                    .foregroundColor(.cream)
                if !traditionVM.selectedTraditionIds.isEmpty {
                    Text("(\(traditionVM.selectedTraditionIds.count))")
                        .font(.notoSans(size: 12, weight: .semibold))
                        .foregroundColor(.gold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.forest)
            .cornerRadius(16)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.cream)
        .accessibilityHint("Returns to results with selected tradition filters applied")
    }
}
