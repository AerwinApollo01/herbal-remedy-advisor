import XCTest
@testable import HerbalRemedyAdvisor

@MainActor
final class AuthViewModelTests: XCTestCase {

    private var sut: AuthViewModel!

    override func setUp() {
        super.setUp()
        AuthViewModel.clearAuthState()
        UserDefaults.standard.removeObject(forKey: "auth_remember_me")
        sut = AuthViewModel()
    }

    override func tearDown() {
        AuthViewModel.clearAuthState()
        UserDefaults.standard.removeObject(forKey: "auth_remember_me")
        sut = nil
        super.tearDown()
    }

    // MARK: - Initial state

    func test_initialState_isLoading() {
        XCTAssertEqual(sut.state, .loading)
    }

    func test_initialRememberMe_defaultsToTrue() {
        XCTAssertTrue(sut.rememberMe)
    }

    func test_initialRememberMe_restoredFalseFromUserDefaults() {
        UserDefaults.standard.set(false, forKey: "auth_remember_me")
        let vm = AuthViewModel()
        XCTAssertFalse(vm.rememberMe)
    }

    func test_initialIsLoading_isFalse() {
        XCTAssertFalse(sut.isLoading)
    }

    func test_initialSignInError_isNil() {
        XCTAssertNil(sut.signInError)
    }

    // MARK: - completeWelcome

    func test_completeWelcome_transitionsToAuthenticated() {
        sut.completeWelcome(userID: "uid_abc", displayName: "Ada")
        XCTAssertEqual(sut.state, .authenticated(userID: "uid_abc", displayName: "Ada"))
    }

    func test_completeWelcome_nilDisplayName_propagates() {
        sut.completeWelcome(userID: "uid_xyz", displayName: nil)
        XCTAssertEqual(sut.state, .authenticated(userID: "uid_xyz", displayName: nil))
    }

    // MARK: - signOut

    func test_signOut_transitionsToUnauthenticatedFirstTime() {
        sut.signOut()
        XCTAssertEqual(sut.state, .unauthenticated(reason: .firstTime))
    }

    func test_signOut_clearsSignInError() {
        sut.signInError = "Some previous error"
        sut.signOut()
        XCTAssertNil(sut.signInError)
    }

    func test_signOut_clearsPasswordResetSent() {
        sut.passwordResetSent = true
        sut.signOut()
        XCTAssertFalse(sut.passwordResetSent)
    }

    // MARK: - sendPasswordReset validation

    func test_sendPasswordReset_emptyEmail_setsError() {
        sut.sendPasswordReset(email: "")
        XCTAssertNotNil(sut.signInError)
    }

    func test_sendPasswordReset_whitespaceOnly_setsError() {
        sut.sendPasswordReset(email: "   ")
        XCTAssertNotNil(sut.signInError)
    }

    // MARK: - Remember Me

    func test_rememberMe_defaultsToTrue_whenNoPreference() {
        XCTAssertTrue(sut.rememberMe)
    }

    func test_rememberMe_restoredFromUserDefaults() {
        UserDefaults.standard.set(false, forKey: "auth_remember_me")
        let vm = AuthViewModel()
        XCTAssertFalse(vm.rememberMe)
    }

    // MARK: - checkOnLaunch — no Firebase user

    func test_checkOnLaunch_noFirebaseUser_transitionsToUnauthenticated() async {
        // Firebase is signed out (setUp calls clearAuthState)
        await sut.checkOnLaunch()
        XCTAssertEqual(sut.state, .unauthenticated(reason: .firstTime))
    }

    // MARK: - AuthState Equatable

    func test_authState_loadingEqualLoading() {
        XCTAssertEqual(AuthState.loading, AuthState.loading)
    }

    func test_authState_differentReason_notEqual() {
        XCTAssertNotEqual(
            AuthState.unauthenticated(reason: .firstTime),
            AuthState.unauthenticated(reason: .revoked)
        )
    }

    func test_authState_authenticated_matchesOnUserIDAndName() {
        XCTAssertEqual(
            AuthState.authenticated(userID: "u1", displayName: "Alice"),
            AuthState.authenticated(userID: "u1", displayName: "Alice")
        )
        XCTAssertNotEqual(
            AuthState.authenticated(userID: "u1", displayName: nil),
            AuthState.authenticated(userID: "u2", displayName: nil)
        )
    }

    func test_authState_firstLogin_equatable() {
        XCTAssertEqual(
            AuthState.firstLogin(userID: "u1", displayName: "Ada"),
            AuthState.firstLogin(userID: "u1", displayName: "Ada")
        )
    }

    // MARK: - Phase 1: Email verification fields

    func test_initialVerificationEmailSent_isFalse() {
        XCTAssertFalse(sut.verificationEmailSent)
    }

    func test_initialIsEmailVerified_isTrue() {
        XCTAssertTrue(sut.isEmailVerified)
    }

    func test_initialDeleteError_isNil() {
        XCTAssertNil(sut.deleteError)
    }

    // MARK: - Phase 1: signOut clears all Phase 1 fields

    func test_signOut_clearsVerificationEmailSent() {
        sut.verificationEmailSent = true
        sut.signOut()
        XCTAssertFalse(sut.verificationEmailSent)
    }

    func test_signOut_doesNotSetDeleteError() {
        sut.deleteError = "previous error"
        sut.signOut()
        // signOut does not touch deleteError — it's scoped to the Settings screen
        // and cleared on next deleteAccount attempt via beginRequest equivalents.
        // Verifying it's untouched (not nil) confirms we haven't accidentally reset it.
        XCTAssertNotNil(sut.deleteError, "signOut must not clear deleteError — that's owned by deleteAccount")
    }

    // MARK: - Phase 1: deleteAccount guard — no double-trigger

    func test_deleteAccount_setsIsLoadingImmediately() {
        XCTAssertFalse(sut.isLoading)
        sut.deleteAccount()
        XCTAssertTrue(sut.isLoading, "isLoading must be true synchronously when deleteAccount is called")
    }

    func test_deleteAccount_whileLoading_isIdempotent() {
        sut.isLoading = true
        sut.deleteError = "previous error"
        sut.deleteAccount() // should be a no-op since isLoading is already true
        // deleteError must not be cleared — the guard short-circuits before that line
        XCTAssertNotNil(sut.deleteError, "deleteAccount must be a no-op when already loading")
    }

    // MARK: - Phase 1: sendPasswordReset clears verificationEmailSent

    func test_sendPasswordReset_emptyEmail_doesNotTouchVerificationSent() {
        sut.verificationEmailSent = true
        sut.sendPasswordReset(email: "")
        // signInError is set (tested elsewhere), but verificationEmailSent must not change
        XCTAssertTrue(sut.verificationEmailSent,
                      "Validation failure in sendPasswordReset must not clear verificationEmailSent")
    }

    // MARK: - Phase 1: offline-tolerant state — AuthState.unauthenticated(reason: .revoked)

    func test_revokedReason_isDistinctFromFirstTime() {
        let revoked   = AuthState.unauthenticated(reason: .revoked)
        let firstTime = AuthState.unauthenticated(reason: .firstTime)
        XCTAssertNotEqual(revoked, firstTime)
    }

    func test_revokedReason_equatable() {
        XCTAssertEqual(
            AuthState.unauthenticated(reason: .revoked),
            AuthState.unauthenticated(reason: .revoked)
        )
    }
}
