import FirebaseAuth
import FirebaseCore
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

        // Firebase isn't configured until GoogleService-Info.plist is added.
        guard FirebaseApp.app() != nil else {
            await MainActor.run { state = .unauthenticated(reason: .firstTime) }
            return
        }

        guard let user = Auth.auth().currentUser else {
            await MainActor.run { state = .unauthenticated(reason: .firstTime) }
            return
        }

        // "Remember me" off: always re-auth on cold launch.
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
            // Token expired or account deleted/disabled.
            EmailAuthService.shared.signOut()
            await MainActor.run { state = .unauthenticated(reason: .revoked) }
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
                state = .authenticated(userID: user.uid, displayName: user.displayName)
            } catch {
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
                state = .firstLogin(userID: user.uid, displayName: nil)
            } catch {
                signInError = error.localizedDescription
            }
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
        state = .unauthenticated(reason: .firstTime)
    }

    // MARK: - Helpers

    private func beginRequest() {
        isLoading = true
        signInError = nil
        passwordResetSent = false
    }

    // MARK: - Test support

    static func clearAuthState() {
        // Route through the guarded helper so this is safe before Firebase is configured.
        EmailAuthService.shared.signOut()
        UserDefaults.standard.removeObject(forKey: "auth_display_name")
        UserDefaults.standard.removeObject(forKey: "auth_remember_me")
    }
}
