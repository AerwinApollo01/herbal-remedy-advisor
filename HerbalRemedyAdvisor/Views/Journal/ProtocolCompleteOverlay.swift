import SwiftUI

struct ProtocolCompleteOverlay: View {
    @EnvironmentObject var journalVM: JournalViewModel
    @State private var trophyScale: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    private var recipe: Remedy? { journalVM.journalRecipe }
    private var tradition: Tradition? {
        guard let tid = recipe?.tid else { return nil }
        return TraditionDatabase.tradition(for: tid)
    }
    private var finalQuote: Quote {
        journalVM.getQuote(for: recipe?.duration ?? 1)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 12/255, green: 22/255, blue: 12/255).opacity(0.97),
                    Color(red: 26/255, green: 46/255, blue: 26/255).opacity(0.97)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    Text("✨🌿✨")
                        .font(.system(size: 30))
                        .kerning(4)

                    // Trophy badge
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(colors: [.gold, .copper], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: 88, height: 88)
                            .overlay(Circle().stroke(Color.gold, lineWidth: 6).scaleEffect(1.1))
                            .shadow(color: .gold.opacity(0.4), radius: 32)
                        Text("🏆")
                            .font(.system(size: 40))
                    }
                    .scaleEffect(trophyScale)
                    .onAppear {
                        if reduceMotion {
                            trophyScale = 1.0
                        } else {
                            withAnimation(.interpolatingSpring(stiffness: 180, damping: 12).delay(0.1)) {
                                trophyScale = 1.18
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation(.spring()) { trophyScale = 1.0 }
                            }
                        }
                    }

                    Text("Protocol Complete!")
                        .font(.notoSerif(size: 26))
                        .foregroundColor(.cream)

                    if let t = tradition {
                        Text("\(t.flag) \(t.name.uppercased())")
                            .font(.notoSans(size: 11, weight: .semibold))
                            .foregroundColor(.fern)
                            .kerning(0.5)
                    }

                    Text("You have honoured an ancient healing tradition and completed your cleanse with dedication. This is an act of genuine self-respect.")
                        .font(.notoSerif(size: 14))
                        .foregroundColor(.mist)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 28)

                    // Stats
                    HStack(spacing: 12) {
                        statCell(value: "\(journalVM.completedDays.count)", label: "DAYS DONE")
                        statCell(value: "\(journalVM.completedDays.count)", label: "STREAK")
                        statCell(value: "100%", label: "COMPLETE")
                    }
                    .padding(.horizontal, 16)

                    Divider().background(Color.mist.opacity(0.15)).padding(.horizontal, 24)

                    Text("A FINAL WORD OF WISDOM")
                        .font(.notoSans(size: 9, weight: .semibold))
                        .foregroundColor(.fern)
                        .kerning(0.5)

                    VStack(spacing: 8) {
                        Text("\"\(finalQuote.q)\"")
                            .notoSerifItalic(size: 13)
                            .foregroundColor(.mist)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        Text("— \(finalQuote.a)")
                            .font(.notoSans(size: 10))
                            .foregroundColor(.gold)
                    }
                    .padding(.horizontal, 28)

                    VStack(spacing: 12) {
                        Button {
                            journalVM.showProtocolOverlay = false
                        } label: {
                            Text("Return to Journal →")
                                .font(.notoSerif(size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(colors: [.sage, .forest], startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(16)
                        }

                        Button {
                            journalVM.showProtocolOverlay = false
                            journalVM.journalRecipe = nil
                        } label: {
                            Text("Explore More Remedies")
                                .font(.notoSerif(size: 13))
                                .foregroundColor(.mist)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.mist.opacity(0.3), lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .padding(.top, 48)
            }
        }
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.notoSerif(size: 20, weight: .bold))
                .foregroundColor(.gold)
            Text(label)
                .font(.notoSans(size: 9, weight: .semibold))
                .foregroundColor(.mist)
                .kerning(0.3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.07))
        .cornerRadius(12)
    }
}
