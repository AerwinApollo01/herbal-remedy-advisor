import FirebaseAuth
import FirebaseCore
import Foundation

// MARK: - EmailAuthService

final class EmailAuthService {

    static let shared = EmailAuthService()
    private init() {}

    private var isConfigured: Bool { FirebaseApp.app() != nil }

    var currentUser: User? {
        guard isConfigured else { return nil }
        return Auth.auth().currentUser
    }

    // MARK: - Auth actions

    func signIn(email: String, password: String) async throws -> User {
        guard isConfigured else { throw notConfiguredError() }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user
        } catch {
            throw friendly(error)
        }
    }

    func signUp(email: String, password: String) async throws -> User {
        guard isConfigured else { throw notConfiguredError() }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result.user
        } catch {
            throw friendly(error)
        }
    }

    func sendPasswordReset(email: String) async throws {
        guard isConfigured else { throw notConfiguredError() }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw friendly(error)
        }
    }

    private func notConfiguredError() -> Error {
        NSError(domain: "EmailAuthService", code: -1,
                userInfo: [NSLocalizedDescriptionKey:
                    "Firebase is not set up yet. Add GoogleService-Info.plist to the project."])
    }

    func signOut() {
        guard isConfigured else { return }
        try? Auth.auth().signOut()
    }

    func reloadCurrentUser() async throws {
        guard isConfigured else { return }
        try await Auth.auth().currentUser?.reload()
    }

    // MARK: - Human-readable error messages

    private func friendly(_ error: Error) -> Error {
        let code = (error as NSError).code
        let message: String
        switch code {
        case AuthErrorCode.wrongPassword.rawValue,
             AuthErrorCode.invalidCredential.rawValue:
            message = "Incorrect email or password. Please try again."
        case AuthErrorCode.userNotFound.rawValue:
            message = "No account found with that email address."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            message = "An account with this email already exists. Try signing in instead."
        case AuthErrorCode.invalidEmail.rawValue:
            message = "Please enter a valid email address."
        case AuthErrorCode.weakPassword.rawValue:
            message = "Password must be at least 6 characters."
        case AuthErrorCode.networkError.rawValue:
            message = "Network error. Check your connection and try again."
        case AuthErrorCode.tooManyRequests.rawValue:
            message = "Too many attempts. Please wait a moment and try again."
        case AuthErrorCode.userDisabled.rawValue:
            message = "This account has been disabled. Please contact support."
        case AuthErrorCode.operationNotAllowed.rawValue:
            message = "Email/password sign-in is not enabled. Contact support."
        default:
            message = "Something went wrong. Please try again."
        }
        return NSError(domain: "EmailAuthService", code: code,
                       userInfo: [NSLocalizedDescriptionKey: message])
    }
}
