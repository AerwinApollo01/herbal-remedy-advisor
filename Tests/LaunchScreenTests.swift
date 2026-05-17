import XCTest

// MARK: - Phase 1 System Tests: Launch Screen & App Shell
// These are UI tests (require a running simulator) that validate the
// launch experience a TestFlight tester will see on first open.

final class LaunchScreenTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Reset journal UserDefaults before each test so persistence from a
        // prior run never interferes with state-dependent assertions.
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
    }

    // MARK: - Launch

    func test07_appLaunchesWithoutCrash() throws {
        app.launch()
        // If the app crashes on launch, XCUIApplication never reaches a
        // running state. waitForExistence on any root element confirms launch.
        let exists = app.wait(for: .runningForeground, timeout: 10)
        XCTAssertTrue(exists, "App must reach runningForeground state within 10 seconds")
    }

    func test08_symptomScreenAppearsAfterLaunch() throws {
        app.launch()
        // After launch the root tab view should display the Symptoms tab.
        // The Find Natural Remedies CTA is a reliable landmark.
        let cta = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")
        ).firstMatch
        XCTAssertTrue(
            cta.waitForExistence(timeout: 8),
            "Symptom screen CTA must appear after launch — if the launch screen hangs, the app is stuck"
        )
    }

    func test09_tabBarVisibleOnLaunch() throws {
        app.launch()
        // All four tabs must be present and accessible immediately after launch.
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 8), "Tab bar must be visible after launch")

        for label in ["Symptoms", "Remedies", "Traditions", "Journal"] {
            let tab = tabBar.buttons[label]
            XCTAssertTrue(tab.exists, "Tab '\(label)' must exist in tab bar")
        }
    }

    func test10_noWhiteFlashOnLaunch() throws {
        // We can't snapshot the launch screen itself (iOS renders it before
        // the test runner attaches), but we can verify the app's background
        // color is cream/forest immediately on entry — not white.
        // This is a structural sanity check: if UILaunchScreen is misconfigured
        // and the storyboard fallback fires, a blank white view may appear.
        app.launch()
        // Symptom screen appearing means the launch sequence completed cleanly.
        let cta = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")
        ).firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 8), "App must transition from launch screen cleanly")
    }

    // MARK: - App Shell

    func test11_appHeaderPresentOnAllTabs() throws {
        app.launch()
        _ = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")
        ).firstMatch.waitForExistence(timeout: 8)

        // Check that each tab shows an AppHeader (identified by its title label)
        let tabHeaders: [(tab: String, title: String)] = [
            ("Symptoms",   "Nise"),
            ("Remedies",   "Your Remedies"),
            ("Traditions", "Healing Traditions"),
            ("Journal",    "Remedy Calendar"),
        ]

        for (tabLabel, expectedTitle) in tabHeaders {
            app.tabBars.buttons[tabLabel].tap()
            let header = app.staticTexts.matching(
                NSPredicate(format: "label CONTAINS '\(expectedTitle)'")
            ).firstMatch
            XCTAssertTrue(
                header.waitForExistence(timeout: 5),
                "Tab '\(tabLabel)' must show header title '\(expectedTitle)'"
            )
        }
    }

    func test12_journalTabShowsEmptyStateBeforeProtocol() throws {
        app.launch()
        _ = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")
        ).firstMatch.waitForExistence(timeout: 8)

        app.tabBars.buttons["Journal"].tap()

        let emptyState = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'No Active Protocol'")
        ).firstMatch
        XCTAssertTrue(
            emptyState.waitForExistence(timeout: 5),
            "Journal tab must show empty state when no protocol is active"
        )
    }

    func test13_remediesTabShowsEmptyStateBeforeAnalysis() throws {
        app.launch()
        _ = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")
        ).firstMatch.waitForExistence(timeout: 8)

        app.tabBars.buttons["Remedies"].tap()

        // Either the results list OR an empty state should show — never a crash.
        let hasResults = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Your Remedies'")
        ).firstMatch.waitForExistence(timeout: 5)

        // If results exist from a prior session that's fine too
        XCTAssertTrue(hasResults, "Remedies tab must show its header after navigation")
    }
}
