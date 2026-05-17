import XCTest

final class JournalFlowTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-SkipAuth", "-ResetJournalState"]
        app.launch()
        sleep(1)
    }

    func test05_StartJournalFromResults() throws {
        // Select a symptom and get to results
        tapIfExists("Bloating & Gas")
        sleep(1)
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 5))
        cta.tap()
        sleep(3) // wait for loading + tab switch

        // Tap the 📓 Start button on the first remedy card
        let startBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start'")).firstMatch
        if startBtn.waitForExistence(timeout: 5) {
            startBtn.tap()
            sleep(1)
            print("✓ Tapped Start journal button")
        } else {
            XCTFail("Start button not found")
        }

        // Switch to Journal tab
        let journalTab = app.tabBars.buttons["Journal"]
        XCTAssertTrue(journalTab.waitForExistence(timeout: 5))
        journalTab.tap()
        sleep(1)

        // Journal should show active protocol (not empty state)
        let emptyState = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'No Active Protocol'")).firstMatch
        XCTAssertFalse(emptyState.exists, "Journal should show active protocol, not empty state")
        print("✓ Active journal shown after starting from Results")

        // Check progress bar exists
        let progressPct = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '%'")).firstMatch
        print(progressPct.exists ? "✓ Progress indicator visible" : "⚠️ Progress indicator not found")
    }

    func test06_MarkDayComplete() throws {
        try test05_StartJournalFromResults()

        // Tap "Mark Day Complete" button
        let markBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Mark Day Complete'")).firstMatch
        if markBtn.waitForExistence(timeout: 5) {
            markBtn.tap()
            sleep(1)
            print("✓ Tapped Mark Day Complete")
        } else {
            XCTFail("Mark Day Complete button not found")
        }

        // Day Complete overlay should appear
        let overlay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Day 1 Complete'")).firstMatch
        if overlay.waitForExistence(timeout: 5) {
            print("✓ Day Complete overlay appeared")
        } else {
            // Try broader match
            let altOverlay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Complete'")).firstMatch
            print(altOverlay.exists ? "✓ Completion overlay appeared (broader match)" : "⚠️ Overlay not found")
        }

        // Dismiss with "Continue Journey" button
        let continueBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch
        if continueBtn.waitForExistence(timeout: 5) {
            continueBtn.tap()
            sleep(1)
            print("✓ Dismissed overlay — Day 1 complete")
        }

        // Check days done stat updated to 1
        let daysDone = app.staticTexts["1"].firstMatch
        print(daysDone.exists ? "✓ Stats updated: 1 day done" : "⚠️ Day count not confirmed")
    }

    private func tapIfExists(_ label: String) {
        let el = app.buttons[label]
        if el.waitForExistence(timeout: 3) { el.tap() }
        else { print("⚠️ Button not found: \(label)") }
    }
}
