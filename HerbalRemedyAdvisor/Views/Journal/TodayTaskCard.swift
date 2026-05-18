import SwiftUI

struct TodayTaskCard: View {
    @EnvironmentObject var journalVM: JournalViewModel

    var body: some View {
        VStack(spacing: 0) {

            // Header
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("DAY \(journalVM.currentDayNumber) PROTOCOL")
                        .font(.notoSans(size: 9, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .kerning(0.5)
                        .textCase(.uppercase)
                    Spacer()
                    Image(systemName: journalVM.journalRecipe?.sfSymbol ?? "leaf.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                Text(journalVM.journalRecipe?.name ?? "")
                    .font(.notoSerif(size: 15))
                    .foregroundColor(.white)
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

            // Read-only preparation steps
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array((journalVM.journalRecipe?.steps ?? []).enumerated()), id: \.offset) { i, step in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(i + 1)")
                            .font(.notoSans(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                            .background(Color(hex: journalVM.journalRecipe?.color ?? "#1A2E1A").opacity(0.85))
                            .clipShape(Circle())
                            .padding(.top, 13)

                        Text(step)
                            .font(.notoSans(size: 11))
                            .foregroundColor(.subtext)
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
