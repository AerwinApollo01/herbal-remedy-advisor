import XCTest

final class AuthFlowTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - Email login screen structure

    func test01_loginScreen_appearsOnFirstLaunch() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Nise"].waitForExistence(timeout: 5))
    }

    func test02_loginScreen_showsTagline() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Ancient wisdom, daily practice"].waitForExistence(timeout: 5))
    }

    func test03_loginScreen_showsEmailField() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        let emailField = app.textFields["Email address"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
    }

    func test04_loginScreen_showsPasswordField() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        let pwField = app.secureTextFields["Password"]
        XCTAssertTrue(pwField.waitForExistence(timeout: 5))
    }

    func test05_loginScreen_showsSignInButton() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        let btn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Sign In'")).firstMatch
        XCTAssertTrue(btn.waitForExistence(timeout: 5))
    }

    func test06_loginScreen_showsForgotPassword() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        let forgot = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Forgot'")).firstMatch
        XCTAssertTrue(forgot.waitForExistence(timeout: 5))
    }

    func test07_loginScreen_canToggleToSignUp() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        let createBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch
        XCTAssertTrue(createBtn.waitForExistence(timeout: 5))
        createBtn.tap()
        // After toggling, should see "Create Account" primary button
        let createAccount = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create Account'")).firstMatch
        XCTAssertTrue(createAccount.waitForExistence(timeout: 3))
    }

    func test08_loginScreen_signUpShowsConfirmField() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch.tap()
        let confirm = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 3))
    }

    func test09_loginScreen_noRevokedBannerOnFirstLaunch() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        _ = app.textFields["Email address"].waitForExistence(timeout: 5)
        let revoked = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'session expired'")
        ).firstMatch
        XCTAssertFalse(revoked.exists)
    }

    // MARK: - Skip-auth bypass (CI / simulator flow)

    func test10_skipAuth_bypassesLoginAndShowsTabBar() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))
    }

    func test11_skipAuth_symptomTabIsActive() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        let symptomsTab = app.tabBars.buttons["Symptoms"]
        XCTAssertTrue(symptomsTab.waitForExistence(timeout: 5))
        XCTAssertTrue(symptomsTab.isSelected)
    }

    func test12_skipAuth_allFourTabsPresent() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Symptoms"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Remedies"].exists)
        XCTAssertTrue(app.tabBars.buttons["Journal"].exists)
        XCTAssertTrue(app.tabBars.buttons["Traditions"].exists)
    }

    func test13_skipAuth_journalTabShowsEmptyStateWhenReset() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        app.tabBars.buttons["Journal"].tap()
        let noProtocol = app.staticTexts
            .containing(NSPredicate(format: "label CONTAINS[c] 'protocol'")).firstMatch
        XCTAssertTrue(noProtocol.waitForExistence(timeout: 5))
    }

    // MARK: - Phase 1: App rename — login wordmark

    func test14_loginScreen_showsNiseWordmark() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        let wordmark = app.staticTexts["Nise"]
        XCTAssertTrue(wordmark.waitForExistence(timeout: 5),
                      "Login screen must show 'Nise' wordmark — stale 'Herbal Remedy Advisor' text indicates the rename didn't propagate")
    }

    // MARK: - Phase 1: Password strength bar

    func test15_signUp_passwordStrengthBarAppearsAfterTyping() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        // Switch to sign-up mode
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch
            .waitForExistence(timeout: 5)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch.tap()

        // Type a short password — strength bar should appear
        let pwField = app.secureTextFields["Password"]
        XCTAssertTrue(pwField.waitForExistence(timeout: 3))
        pwField.tap()
        pwField.typeText("abc")

        // Strength label (Weak / Fair / Strong) must be visible
        let strengthLabel = app.staticTexts.matching(
            NSPredicate(format: "label IN {'Weak', 'Fair', 'Strong'}")
        ).firstMatch
        XCTAssertTrue(strengthLabel.waitForExistence(timeout: 3),
                      "Password strength label must appear when a password is typed in sign-up mode")
    }

    func test16_signUp_shortPassword_showsWeakStrength() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch
            .waitForExistence(timeout: 5)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch.tap()

        let pwField = app.secureTextFields["Password"]
        XCTAssertTrue(pwField.waitForExistence(timeout: 3))
        pwField.tap()
        pwField.typeText("abc12") // 5 chars — < 8, must be Weak

        let weakLabel = app.staticTexts["Weak"]
        XCTAssertTrue(weakLabel.waitForExistence(timeout: 3),
                      "A 5-character password must show 'Weak' strength")
    }

    func test17_signUp_strengthBarHidesWhenTogglingBackToSignIn() {
        // Verifies the strength bar cleans up when the user switches back to sign-in mode.
        // The Weak/Fair/Strong label thresholds are covered by PasswordStrengthLogicTests (unit tests).
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()

        // Enter sign-up mode and type a password so the strength bar appears
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch
            .waitForExistence(timeout: 5)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch.tap()

        let pwField = app.secureTextFields["Password"]
        XCTAssertTrue(pwField.waitForExistence(timeout: 3))
        pwField.tap()
        pwField.typeText("abc") // short → Weak bar appears

        let strengthBar = app.staticTexts["Weak"]
        XCTAssertTrue(strengthBar.waitForExistence(timeout: 3), "Strength bar must appear in sign-up mode")

        // Switch back to sign-in mode — bar must disappear
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Already have an account'")).firstMatch
            .waitForExistence(timeout: 3)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Already have an account'")).firstMatch.tap()

        let anyStrengthLabel = app.staticTexts.matching(
            NSPredicate(format: "label IN {'Weak', 'Fair', 'Strong'}")
        ).firstMatch
        XCTAssertFalse(anyStrengthLabel.waitForExistence(timeout: 2),
                       "Strength bar must disappear when switching back to sign-in mode")
    }

    func test18_signUp_passwordStrengthBarHiddenInSignInMode() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        // Stay in sign-in mode — do NOT tap "Create one"
        let pwField = app.secureTextFields["Password"]
        XCTAssertTrue(pwField.waitForExistence(timeout: 5))
        pwField.tap()
        pwField.typeText("anything")

        let strengthLabel = app.staticTexts.matching(
            NSPredicate(format: "label IN {'Weak', 'Fair', 'Strong'}")
        ).firstMatch
        XCTAssertFalse(strengthLabel.exists,
                       "Password strength bar must NOT appear in sign-in mode")
    }

    func test19_signUp_confirmPasswordMismatch_showsError() {
        app.launchArguments = ["-ResetAuthState", "-ResetJournalState"]
        app.launch()
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch
            .waitForExistence(timeout: 5)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch.tap()

        let pwField      = app.secureTextFields["Password"]
        let confirmField = app.secureTextFields["Confirm password"]
        XCTAssertTrue(pwField.waitForExistence(timeout: 3))
        XCTAssertTrue(confirmField.waitForExistence(timeout: 3))

        pwField.tap(); pwField.typeText("Password123")
        confirmField.tap(); confirmField.typeText("Mismatch999")
        // Press return to call onSubmit { focus = nil }, dismissing the keyboard
        confirmField.typeText("\n")
        sleep(1)

        let mismatchMsg = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'match'")
        ).firstMatch
        XCTAssertTrue(mismatchMsg.waitForExistence(timeout: 3),
                      "Mismatched passwords must show a 'don't match' error below the confirm field")
    }

    // MARK: - Phase 1: Settings — Sign Out & Delete Account

    func test20_settings_signOutButtonPresent() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        app.tabBars.buttons["About"].waitForExistence(timeout: 5)
        app.tabBars.buttons["About"].tap()

        let signOutBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Sign Out'")).firstMatch
        XCTAssertTrue(signOutBtn.waitForExistence(timeout: 5),
                      "About/Settings screen must contain a Sign Out button")
    }

    func test21_settings_deleteAccountButtonPresent() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        app.tabBars.buttons["About"].waitForExistence(timeout: 5)
        app.tabBars.buttons["About"].tap()

        let deleteBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Delete Account'")).firstMatch
        XCTAssertTrue(deleteBtn.waitForExistence(timeout: 5),
                      "About/Settings screen must contain a Delete Account button")
    }

    func test22_settings_signOutTapShowsConfirmationDialog() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        app.tabBars.buttons["About"].waitForExistence(timeout: 5)
        app.tabBars.buttons["About"].tap()

        let signOutBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Sign Out'")).firstMatch
        XCTAssertTrue(signOutBtn.waitForExistence(timeout: 5))
        signOutBtn.tap()

        let confirmDialog = app.buttons.matching(
            NSPredicate(format: "label == 'Sign Out'")
        ).firstMatch
        XCTAssertTrue(confirmDialog.waitForExistence(timeout: 3),
                      "Tapping Sign Out must show a confirmation dialog with a destructive 'Sign Out' action")

        // confirmationDialog presents as an action sheet — Cancel lives in app.sheets
        let cancel = app.sheets.buttons["Cancel"]
        if cancel.waitForExistence(timeout: 2) { cancel.tap() }
    }

    func test23_settings_deleteAccountTapShowsConfirmationDialog() {
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        app.tabBars.buttons["About"].waitForExistence(timeout: 5)
        app.tabBars.buttons["About"].tap()

        let deleteBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Delete Account'")).firstMatch
        XCTAssertTrue(deleteBtn.waitForExistence(timeout: 5))
        deleteBtn.tap()

        let warningText = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'cannot be undone'")
        ).firstMatch
        XCTAssertTrue(warningText.waitForExistence(timeout: 3),
                      "Delete Account dialog must display an 'cannot be undone' warning")

        let cancel = app.sheets.buttons["Cancel"]
        if cancel.waitForExistence(timeout: 2) { cancel.tap() }
    }
}
