import XCTest

/// Captures a screenshot of every app screen and saves PNGs to /tmp/nise_screens/.
/// Run with: xcodebuild test -scheme HerbalRemedyAdvisor -testPlan ... -only-testing ScreenshotCaptureTests
final class ScreenshotCaptureTests: XCTestCase {

    var app: XCUIApplication!
    private let outputDir = "/tmp/nise_screens"

    override func setUpWithError() throws {
        continueAfterFailure = false
        try FileManager.default.createDirectory(atPath: outputDir,
                                                withIntermediateDirectories: true)
    }

    // MARK: - Login screens (reset auth so we see the login flow)

    func test01_LoginScreen() throws {
        app = XCUIApplication()
        app.launchArguments = ["-ResetAuthState"]
        app.launch()
        sleep(2)
        save("01_login_signin")

        // Switch to sign-up mode
        let toggle = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Create one'")).firstMatch
        if toggle.waitForExistence(timeout: 3) { toggle.tap(); sleep(1) }
        save("02_login_signup")
    }

    // MARK: - Onboarding (right after first sign-up, hard to replicate in UI test — skip)

    // MARK: - Main app screens

    func test02_SymptomsEmpty() throws {
        launchAuthenticated()
        save("03_symptoms_empty")
    }

    func test03_SymptomsSelected() throws {
        launchAuthenticated()
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        tapIfExists("Digestive Issues")
        sleep(1)
        save("04_symptoms_selected")
    }

    func test04_Loading() throws {
        launchAuthenticated()
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        if cta.waitForExistence(timeout: 3) { cta.tap() }
        sleep(1) // catch mid-load
        save("05_loading")
        sleep(3) // let it finish
    }

    func test05_RemediesResults() throws {
        launchAuthenticated()
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        if cta.waitForExistence(timeout: 3) { cta.tap() }
        sleep(4)
        save("06_remedies_results")
    }

    func test06_RemediesEmpty() throws {
        launchAuthenticated()
        tapTabBar("Remedies")
        sleep(1)
        save("07_remedies_empty_state")
    }

    func test07_RemedyDetail() throws {
        launchAuthenticated()
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        if cta.waitForExistence(timeout: 3) { cta.tap() }
        sleep(4)
        tapTabBar("Remedies")
        let viewBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'View Protocol'")).firstMatch
        if viewBtn.waitForExistence(timeout: 3) { viewBtn.tap(); sleep(1) }
        save("08_remedy_detail")
    }

    func test08_TraditionsFilter() throws {
        launchAuthenticated()
        tapTabBar("Traditions")
        sleep(1)
        save("09_traditions_filter")
    }

    func test09_TraditionDetail() throws {
        launchAuthenticated()
        tapTabBar("Traditions")
        sleep(1)
        let firstCard = app.buttons.element(boundBy: 0)
        if firstCard.waitForExistence(timeout: 3) { firstCard.tap(); sleep(1) }
        save("10_tradition_detail")
    }

    func test10_JournalEmpty() throws {
        launchAuthenticated(resetJournal: true)
        tapTabBar("Journal")
        sleep(1)
        save("11_journal_empty")
    }

    func test11_JournalActive() throws {
        launchAuthenticated()
        // Start a protocol
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        if cta.waitForExistence(timeout: 3) { cta.tap() }
        sleep(4)
        tapTabBar("Remedies")
        let startBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start'")).firstMatch
        if startBtn.waitForExistence(timeout: 3) { startBtn.tap(); sleep(1) }
        tapTabBar("Journal")
        sleep(1)
        save("12_journal_active")
    }

    func test12_ReplaceAlert() throws {
        launchAuthenticated()
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        if cta.waitForExistence(timeout: 3) { cta.tap() }
        sleep(4)
        tapTabBar("Remedies")
        // Start first protocol
        let startBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start'")).firstMatch
        if startBtn.waitForExistence(timeout: 3) { startBtn.tap(); sleep(1) }
        tapTabBar("Remedies")
        // Tap start on a second one to trigger replace dialog
        let startBtn2 = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start'")).firstMatch
        if startBtn2.waitForExistence(timeout: 3) { startBtn2.tap(); sleep(1) }
        save("13_replace_protocol_alert")
    }

    func test13_Settings() throws {
        launchAuthenticated()
        tapTabBar("About")
        sleep(1)
        save("14_settings_about")
    }

    func test14_SafetyDisclaimer() throws {
        launchAuthenticated()
        tapTabBar("About")
        sleep(1)
        let disclaimer = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Safety Disclaimer'")).firstMatch
        if disclaimer.waitForExistence(timeout: 3) { disclaimer.tap(); sleep(1) }
        save("15_safety_disclaimer")
    }

    func test15_SignOutDialog() throws {
        launchAuthenticated()
        tapTabBar("About")
        sleep(1)
        let signOut = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Sign Out'")).firstMatch
        if signOut.waitForExistence(timeout: 3) { signOut.tap(); sleep(1) }
        save("16_signout_dialog")
    }

    // MARK: - Helpers

    private func launchAuthenticated(resetJournal: Bool = false) {
        app = XCUIApplication()
        var args = ["-SkipAuth"]
        if resetJournal { args.append("-ResetJournalState") }
        app.launchArguments = args
        app.launch()
        sleep(2)
    }

    private func tapTabBar(_ label: String) {
        let tab = app.tabBars.buttons[label]
        if tab.waitForExistence(timeout: 3) { tab.tap() }
    }

    private func tapIfExists(_ label: String) {
        let el = app.buttons[label]
        if el.waitForExistence(timeout: 2) { el.tap() }
    }

    private func save(_ name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let data = screenshot.pngRepresentation
        let path = "\(outputDir)/\(name).png"
        try? data.write(to: URL(fileURLWithPath: path))
    }
}
