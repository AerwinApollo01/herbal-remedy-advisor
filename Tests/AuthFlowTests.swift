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
        XCTAssertTrue(app.staticTexts["Herbal Remedy Advisor"].waitForExistence(timeout: 5))
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
}
