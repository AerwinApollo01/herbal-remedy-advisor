import SwiftUI

struct DayCompleteOverlay: View {
    @EnvironmentObject var journalVM: JournalViewModel
    @State private var emojiScale: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    private var completedCount: Int { journalVM.completedDays.count }
    private var daysLeft: Int { journalVM.daysLeft }
    private var totalDays: Int { journalVM.journalRecipe?.duration ?? 0 }
    private var protocolName: String { journalVM.journalRecipe?.name ?? "your protocol" }

    private var nextDayQuote: Quote {
        journalVM.getQuote(for: journalVM.currentDayNumber)
    }

    // Item 5: Day 3 milestone
    private var milestoneMessage: String? {
        guard completedCount == 3 else { return nil }
        return "Most people quit here. You didn't."
    }

    // Item 7: 25 / 50 / 75 % progress callout
    // Uses integer rounding so milestones fire on real protocol durations (7, 14, 21, 30 days).
    private var progressCallout: String? {
        guard totalDays > 0, milestoneMessage == nil else { return nil }
        let quarterDay       = (totalDays + 2) / 4
        let halfDay          = totalDays / 2
        let threeQuarterDay  = (3 * totalDays + 2) / 4
        switch completedCount {
        case quarterDay:      return "You're a quarter of the way through \(protocolName)."
        case halfDay:         return "You're halfway through \(protocolName)."
        case threeQuarterDay: return "Three-quarters of the way through \(protocolName)."
        default:              return nil
        }
    }

    var body: some View {
        ZStack {
            Color(red: 26/255, green: 46/255, blue: 26/255).opacity(0.92)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.fern.opacity(0.25))
                        .frame(width: 80, height: 80)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56, weight: .semibold))
                        .foregroundColor(.fern)
                }
                .scaleEffect(emojiScale)
                .onAppear {
                    if reduceMotion {
                        emojiScale = 1.0
                    } else {
                        withAnimation(.interpolatingSpring(stiffness: 200, damping: 12)) {
                            emojiScale = 1.18
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.spring()) { emojiScale = 1.0 }
                        }
                    }
                }

                Text("Day \(completedCount) Complete!")
                    .font(.notoSerif(size: 24))
                    .foregroundColor(.cream)

                Text("\(completedCount) day\(completedCount == 1 ? "" : "s") complete · \(daysLeft) day\(daysLeft == 1 ? "" : "s") remaining")
                    .font(.notoSans(size: 13))
                    .foregroundColor(.mist)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Streak pill
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Text("\(completedCount)-day streak")
                        .font(.notoSans(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 6)
                .background(Color.gold)
                .cornerRadius(20)

                // Item 5: Day 3 milestone message
                if let milestone = milestoneMessage {
                    Text(milestone)
                        .font(.notoSerif(size: 15))
                        .foregroundColor(.cream)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.fern.opacity(0.18))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.fern.opacity(0.35), lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                }

                // Item 7: 25/50/75% progress callout
                if let callout = progressCallout {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.gold)
                        Text(callout)
                            .font(.notoSans(size: 13))
                            .foregroundColor(.gold)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Quote preview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tomorrow's wisdom:")
                        .font(.notoSans(size: 9, weight: .semibold))
                        .foregroundColor(.fern)
                    Text("\"\(nextDayQuote.q)\"")
                        .notoSerifItalic(size: 12)
                        .foregroundColor(.mist)
                        .lineSpacing(4)
                    Text("— \(nextDayQuote.a)")
                        .font(.notoSans(size: 10))
                        .foregroundColor(.fern)
                }
                .padding(14)
                .background(Color.white.opacity(0.08))
                .cornerRadius(12)
                .padding(.horizontal, 24)

                Text("Your daily reminder is set")
                    .font(.notoSans(size: 11))
                    .foregroundColor(.fern)

                Button {
                    journalVM.showDayOverlay = false
                } label: {
                    Text("Continue Journey →")
                        .font(.notoSerif(size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .padding(.horizontal, 30)
                        .background(Color.fern)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 48)
                .accessibilityHint("Dismisses this celebration and returns to your journal")
            }
            .padding(.vertical, 40)
        }
    }
}
