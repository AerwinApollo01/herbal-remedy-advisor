import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var authVM: AuthViewModel

    let userID: String
    let displayName: String?

    private var greeting: String {
        if let name = displayName, !name.isEmpty {
            return "Welcome, \(name.components(separatedBy: " ").first ?? name)."
        }
        return "Welcome."
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.forest, .moss],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Hero
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.fern)
                        .padding(.top, 72)
                        .padding(.bottom, 20)

                    Text(greeting)
                        .font(.notoSerif(size: 30, weight: .bold))
                        .foregroundColor(.cream)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)

                    // MARK: Philosophy
                    VStack(spacing: 14) {
                        Text("Eight living traditions. Eleven time-tested remedies. One daily practice.")
                            .font(.notoSerif(size: 16))
                            .foregroundColor(.mist)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        Text("Select your symptoms, explore what healers across cultures have used for centuries, and track your protocol — one day at a time.")
                            .font(.notoSans(size: 13))
                            .foregroundColor(.mist.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 48)

                    // MARK: Tradition flag row
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(TraditionDatabase.all) { tradition in
                                VStack(spacing: 6) {
                                    TraditionFlagView(tradition: tradition, size: 38)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.mist.opacity(0.3), lineWidth: 1))
                                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

                                    Text(tradition.name.components(separatedBy: " ").first ?? tradition.name)
                                        .font(.notoSans(size: 8, weight: .semibold))
                                        .foregroundColor(.mist.opacity(0.6))
                                        .kerning(0.2)
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 56)

                    // MARK: CTA
                    Button {
                        authVM.completeWelcome(userID: userID, displayName: displayName)
                    } label: {
                        HStack(spacing: 10) {
                            Text("Let's Begin")
                                .font(.notoSerif(size: 16))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.forest)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color.cream)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .accessibilityLabel("Let's Begin — enter the app")
                }
            }
        }
    }
}
