import SwiftUI

struct DayCompleteOverlay: View {
    @EnvironmentObject var journalVM: JournalViewModel
    @State private var emojiScale: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    private var completedCount: Int { journalVM.completedDays.count }
    private var daysLeft: Int { journalVM.daysLeft }
    private var nextDayQuote: Quote {
        journalVM.getQuote(for: journalVM.currentDayNumber)
    }

    var body: some View {
        ZStack {
            Color(red: 26/255, green: 46/255, blue: 26/255).opacity(0.92)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("✅")
                    .font(.system(size: 56))
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
                Text("🔥 \(completedCount)-day streak")
                    .font(.notoSans(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(Color.gold)
                    .cornerRadius(20)

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

                Text("Your daily reminder is set ✓")
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
