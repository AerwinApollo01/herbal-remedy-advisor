import FirebaseCore
import SwiftUI

@main
struct HerbalRemedyAdvisorApp: App {
    @StateObject private var authVM    = AuthViewModel()
    @StateObject private var symptomVM = SymptomViewModel()
    @StateObject private var journalVM = JournalViewModel()
    @StateObject private var traditionVM = TraditionViewModel()

    init() {
        // Only configure Firebase when the plist is present.
        // The app runs in unauthenticated-only mode until it is added.
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        }
        if CommandLine.arguments.contains("-ResetJournalState") {
            JournalViewModel.clearPersistedState(userID: "ui_test_user")
        }
        if CommandLine.arguments.contains("-ResetAuthState") {
            AuthViewModel.clearAuthState()
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch authVM.state {
                case .loading:
                    Color("LaunchBackground").ignoresSafeArea()

                case .unauthenticated(let reason):
                    LoginScreen(isRevoked: reason == .revoked)
                        .environmentObject(authVM)

                case .firstLogin(let userID, let displayName):
                    OnboardingScreen(userID: userID, displayName: displayName)
                        .environmentObject(authVM)

                case .authenticated:
                    RootTabView()
                        .environmentObject(authVM)
                        .environmentObject(symptomVM)
                        .environmentObject(journalVM)
                        .environmentObject(traditionVM)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authVM.state)
            .preferredColorScheme(.light)
            .task { await authVM.checkOnLaunch() }
            .onChange(of: authVM.state) { newState in
                if case .authenticated(let userID, _) = newState {
                    journalVM.configure(userID: userID)
                }
            }
        }
    }
}
