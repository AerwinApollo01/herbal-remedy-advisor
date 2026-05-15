import SwiftUI

struct TodayTaskCard: View {
    @EnvironmentObject var journalVM: JournalViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Today's Protocol")
                    .font(.notoSerif(size: 13))
                    .foregroundColor(.white)
                Spacer()
                Text("Day \(journalVM.currentDayNumber)")
                    .font(.notoSans(size: 10))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: journalVM.journalRecipe?.color ?? "#1A2E1A"),
                        Color(hex: journalVM.journalRecipe?.color ?? "#1A2E1A").opacity(0.75)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )

            // Tasks
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array((journalVM.journalRecipe?.steps ?? []).enumerated()), id: \.offset) { i, step in
                    HStack(alignment: .top, spacing: 12) {
                        Button { journalVM.toggleTask(i) } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.mist, lineWidth: 1.5)
                                    .frame(width: 20, height: 20)
                                    .background(
                                        i < journalVM.taskChecked.count && journalVM.taskChecked[i]
                                            ? Color.forest : Color.clear
                                    )
                                    .cornerRadius(6)
                                if i < journalVM.taskChecked.count && journalVM.taskChecked[i] {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .frame(width: 44, height: 44)
                        .accessibilityLabel(step)
                        .accessibilityAddTraits(
                            (i < journalVM.taskChecked.count && journalVM.taskChecked[i])
                                ? .isSelected : []
                        )

                        Text(step)
                            .font(.notoSans(size: 11))
                            .foregroundColor(
                                i < journalVM.taskChecked.count && journalVM.taskChecked[i]
                                    ? .subtext.opacity(0.45) : .subtext
                            )
                            .strikethrough(
                                i < journalVM.taskChecked.count && journalVM.taskChecked[i],
                                color: .subtext.opacity(0.45)
                            )
                            .lineSpacing(3)
                            .padding(.vertical, 12)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    if i < (journalVM.journalRecipe?.steps.count ?? 1) - 1 {
                        Divider().background(Color.mist.opacity(0.6)).padding(.horizontal, 14)
                    }
                }
            }
            .background(Color.white)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 4)
    }
}
