import FirebaseCore
import FirebaseCrashlytics
import SwiftUI

@main
struct HerbalRemedyAdvisorApp: App {

    // MARK: - Environment objects

    @StateObject private var authVM          = AuthViewModel()
    @StateObject private var symptomVM       = SymptomViewModel()
    @StateObject private var journalVM       = JournalViewModel()
    @StateObject private var traditionVM     = TraditionViewModel()

    // Phase 2 additions — decoupled services injected globally
    @StateObject private var userProfileVM   = UserProfileViewModel()
    @StateObject private var appConfig       = AppConfigService()
    @StateObject private var purchaseManager = PurchaseManager.shared

    // MARK: - Init

    init() {
        // Configure Firebase only when GoogleService-Info.plist is present.
        // App runs in unauthenticated-only mode until plist is added to the bundle.
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }

        // Test launch argument overrides
        if CommandLine.arguments.contains("-ResetJournalState") {
            JournalViewModel.clearPersistedState(userID: "ui_test_user")
        }
        if CommandLine.arguments.contains("-ResetAuthState") {
            AuthViewModel.clearAuthState()
        }
    }

    // MARK: - Scene

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
                        .environmentObject(userProfileVM)
                        .environmentObject(appConfig)
                        .environmentObject(purchaseManager)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authVM.state)
            .preferredColorScheme(.light)

            // MARK: Launch tasks
            .task { await authVM.checkOnLaunch() }
            .task { await appConfig.load() }                  // fetch /app_strings/global_config
            .task { await purchaseManager.initialize() }      // StoreKit product + entitlement check

            // MARK: Auth state reactions
            .onChange(of: authVM.state) { newState in
                if case .authenticated(let userID, _) = newState {
                    // Configure per-user services
                    journalVM.configure(userID: userID)
                    userProfileVM.configure(userID: userID)

                    // Fetch wellness goal for symptom boost logic
                    Task {
                        let goal = await FirestoreService.shared.fetchWellnessGoal(uid: userID)
                        await MainActor.run { symptomVM.wellnessGoal = goal }
                    }

                    // Sync StoreKit entitlement → reflect in UserProfileViewModel
                    Task {
                        await purchaseManager.verifyCurrentEntitlement()
                        if purchaseManager.isEntitled {
                            await userProfileVM.applyLifetimeUnlock()
                        }
                    }
                }
            }
        }
    }
}
