import FirebaseAuth
import FirebaseCore
import FirebaseCrashlytics
import Foundation

// MARK: - AuthState

enum AuthState: Equatable {
    case loading
    case unauthenticated(reason: Reason)
    case firstLogin(userID: String, displayName: String?)
    case authenticated(userID: String, displayName: String?)

    enum Reason: Equatable {
        case firstTime
        case revoked    // account deleted or disabled
    }
}

// MARK: - AuthViewModel

class AuthViewModel: ObservableObject {
    @Published var state: AuthState = .loading
    @Published var rememberMe: Bool
    @Published var isLoading: Bool = false
    @Published var signInError: String?
    @Published var passwordResetSent: Bool = false
    @Published var verificationEmailSent: Bool = false
    @Published var isEmailVerified: Bool = true
    @Published var deleteError: String?

    // Handle for the persistent Firebase Auth state listener
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    private enum UDKeys {
        static let rememberMe  = "auth_remember_me"
        static let displayName = "auth_display_name"
    }

    init() {
        if UserDefaults.standard.object(forKey: UDKeys.rememberMe) != nil {
            rememberMe = UserDefaults.standard.bool(forKey: UDKeys.rememberMe)
        } else {
            rememberMe = true
        }
    }

    // MARK: - Launch check

    func checkOnLaunch() async {
        if CommandLine.arguments.contains("-SkipAuth") {
            await MainActor.run {
                state = .authenticated(userID: "ui_test_user", displayName: "Tester")
            }
            return
        }

        guard FirebaseApp.app() != nil else {
            await MainActor.run { state = .unauthenticated(reason: .firstTime) }
            return
        }

        guard let user = Auth.auth().currentUser else {
            await MainActor.run { state = .unauthenticated(reason: .firstTime) }
            return
        }

        if !rememberMe {
            EmailAuthService.shared.signOut()
            await MainActor.run { state = .unauthenticated(reason: .firstTime) }
            return
        }

        do {
            try await user.reload()
            let name = user.displayName ?? UserDefaults.standard.string(forKey: UDKeys.displayName)
            await MainActor.run { state = .authenticated(userID: user.uid, displayName: name) }
        } catch {
            let nsError = error as NSError
            if nsError.code == AuthErrorCode.networkError.rawValue {
                // Offline — trust the cached Firebase token and let them in.
                let name = user.displayName ?? UserDefaults.standard.string(forKey: UDKeys.displayName)
                await MainActor.run { state = .authenticated(userID: user.uid, displayName: name) }
            } else {
                // Token expired or account deleted/disabled.
                EmailAuthService.shared.signOut()
                await MainActor.run { state = .unauthenticated(reason: .revoked) }
            }
        }
    }

    // MARK: - Sign In

    func signIn(email: String, password: String) {
        guard !isLoading else { return }
        beginRequest()
        Task { @MainActor in
            defer { isLoading = false }
            do {
                let user = try await EmailAuthService.shared.signIn(email: email, password: password)
                UserDefaults.standard.set(rememberMe, forKey: UDKeys.rememberMe)
                isEmailVerified = user.isEmailVerified
                if !user.isEmailVerified {
                    verificationEmailSent = false // prompt them to verify
                }
                state = .authenticated(userID: user.uid, displayName: user.displayName)
            } catch {
                Crashlytics.crashlytics().record(error: error)
                signInError = error.localizedDescription
            }
        }
    }

    // MARK: - Sign Up

    func signUp(email: String, password: String) {
        guard !isLoading else { return }
        beginRequest()
        Task { @MainActor in
            defer { isLoading = false }
            do {
                let user = try await EmailAuthService.shared.signUp(email: email, password: password)
                UserDefaults.standard.set(rememberMe, forKey: UDKeys.rememberMe)
                verificationEmailSent = true
                isEmailVerified = false
                state = .firstLogin(userID: user.uid, displayName: nil)
            } catch {
                Crashlytics.crashlytics().record(error: error)
                signInError = error.localizedDescription
            }
        }
    }

    // MARK: - Email Verification

    func resendVerification() {
        Task {
            try? await EmailAuthService.shared.sendEmailVerification()
            await MainActor.run { verificationEmailSent = true }
        }
    }

    // MARK: - Forgot Password

    func sendPasswordReset(email: String) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            signInError = "Enter your email address above, then tap Forgot Password."
            return
        }
        guard !isLoading else { return }
        beginRequest()
        Task { @MainActor in
            defer { isLoading = false }
            do {
                try await EmailAuthService.shared.sendPasswordReset(email: email)
                passwordResetSent = true
            } catch {
                signInError = error.localizedDescription
            }
        }
    }

    // MARK: - Delete Account

    func deleteAccount() {
        guard !isLoading else { return }
        isLoading = true
        deleteError = nil
        Task { @MainActor in
            defer { isLoading = false }
            do {
                try await EmailAuthService.shared.deleteAccount()
                signOut()
            } catch {
                Crashlytics.crashlytics().record(error: error)
                deleteError = error.localizedDescription
            }
        }
    }

    // MARK: - Welcome completion

    func completeWelcome(userID: String, displayName: String?) {
        state = .authenticated(userID: userID, displayName: displayName)
    }

    // MARK: - Sign Out

    func signOut() {
        EmailAuthService.shared.signOut()
        UserDefaults.standard.removeObject(forKey: UDKeys.displayName)
        signInError = nil
        passwordResetSent = false
        verificationEmailSent = false
        state = .unauthenticated(reason: .firstTime)
    }

    // MARK: - Helpers

    private func beginRequest() {
        isLoading = true
        signInError = nil
        passwordResetSent = false
    }

    // MARK: - Live session guard

    /// Installs a persistent Firebase Auth state listener that detects mid-session
    /// token revocation or expiration without requiring a full app relaunch.
    ///
    /// When the listener fires with `nil` user while the app is in an authenticated
    /// state (token revoked server-side, account disabled, or forced sign-out from
    /// another device), this method:
    ///   1. Calls `signOut()` to clear local Firebase credential state.
    ///   2. Posts `nysSessionDidExpire` so `HerbalRemedyAdvisorApp` can flush
    ///      sensitive ViewModel caches (monetization flags, unlocked IDs, etc.).
    ///   3. Transitions `state` to `.unauthenticated(.revoked)`, routing the UI
    ///      to the login screen with an appropriate revocation message.
    ///
    /// Safe to call multiple times — the guard idempotently ignores duplicate calls.
    func attachLiveSessionGuard() {
        guard authStateListenerHandle == nil, FirebaseApp.app() != nil else { return }
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            Task { @MainActor in
                // Only act when Firebase signals a nil user while we believe we are
                // authenticated. Transient nil during sign-in flow is expected and ignored.
                if user == nil, case .authenticated = self.state {
                    Crashlytics.crashlytics().log(
                        "[AuthViewModel] Firebase Auth state listener: session token revoked mid-session — forcing sign-out"
                    )
                    self.signOut()
                    NotificationCenter.default.post(name: .nysSessionDidExpire, object: nil)
                }
            }
        }
    }

    /// Removes the live session listener. Call on app termination or test teardown.
    func detachLiveSessionGuard() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateListenerHandle = nil
        }
    }

    // MARK: - Test support

    static func clearAuthState() {
        EmailAuthService.shared.signOut()
        UserDefaults.standard.removeObject(forKey: "auth_display_name")
        UserDefaults.standard.removeObject(forKey: "auth_remember_me")
    }
}

// MARK: - Notification names

extension Notification.Name {
    /// Posted by `AuthViewModel.attachLiveSessionGuard()` when Firebase signals
    /// that a previously-authenticated session has been revoked server-side.
    /// Observers should flush any sensitive in-memory ViewModel state on receipt.
    static let nysSessionDidExpire = Notification.Name("com.nys.auth.sessionDidExpire")
}
