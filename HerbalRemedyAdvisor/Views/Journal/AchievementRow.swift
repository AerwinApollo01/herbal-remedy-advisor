import SwiftUI

struct AchievementRow: View {
    @EnvironmentObject var journalVM: JournalViewModel

    private struct Achievement {
        let sfSymbol: String
        let color: Color
        let name: String
        let condition: Int
    }

    private let achievements: [Achievement] = [
        .init(sfSymbol: "drop.fill",              color: .sage,   name: "First Brew",   condition: 1),
        .init(sfSymbol: "flame.fill",             color: .copper, name: "3-Day Streak", condition: 3),
        .init(sfSymbol: "medal.fill",             color: .gold,   name: "Week One",     condition: 7),
        .init(sfSymbol: "globe.americas.fill",    color: .forest, name: "Fortnight",    condition: 14),
        .init(sfSymbol: "crown.fill",             color: Color(hex: "#7B35A0"), name: "Herb Master", condition: Int.max)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Achievements")
                .font(.notoSerif(size: 15))
                .foregroundColor(.forest)

            HStack(spacing: 10) {
                ForEach(achievements, id: \.name) { achievement in
                    let unlocked = isUnlocked(achievement)
                    VStack(spacing: 6) {
                        Image(systemName: achievement.sfSymbol)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(unlocked ? achievement.color : .subtext.opacity(0.4))
                        Text(achievement.name)
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(.subtext)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: unlocked ? .black.opacity(0.07) : .clear, radius: 6)
                    .opacity(unlocked ? 1.0 : 0.4)
                    .animation(.spring(response: 0.4), value: unlocked)
                }
            }
        }
    }

    private func isUnlocked(_ achievement: Achievement) -> Bool {
        if achievement.condition == Int.max {
            guard let recipe = journalVM.journalRecipe else { return false }
            return journalVM.completedDays.count >= recipe.duration
        }
        return journalVM.completedDays.count >= achievement.condition
    }
}
