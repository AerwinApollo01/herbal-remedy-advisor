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

        // Tap the "Start Journal" button on the first remedy card
        let startBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Start Journal'")).firstMatch
        XCTAssertTrue(startBtn.waitForExistence(timeout: 5), "Start Journal button not found on Results screen")
        startBtn.tap()
        sleep(1)

        // Handle replace-protocol dialog if it appears (prior state leaked through reset)
        let replaceBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Replace'")).firstMatch
        if replaceBtn.waitForExistence(timeout: 2) {
            replaceBtn.tap()
            sleep(1)
        }

        // Switch to Journal tab
        let journalTab = app.tabBars.buttons["Journal"]
        XCTAssertTrue(journalTab.waitForExistence(timeout: 5))
        journalTab.tap()
        sleep(2)

        // Journal should show active protocol (not empty state)
        let emptyState = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'No Active Protocol'")).firstMatch
        XCTAssertFalse(emptyState.exists, "Journal should show active protocol after starting from Results")
        print("✓ Active journal shown after starting from Results")
    }

    func test06_MarkDayComplete() throws {
        try test05_StartJournalFromResults()

        // Scroll past the calendar grid to reveal the Mark Day Complete button
        app.swipeUp(); sleep(1)
        app.swipeUp(); sleep(1)

        let markBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'today complete'")).firstMatch
        XCTAssertTrue(markBtn.waitForExistence(timeout: 8), "Mark today complete button not found — calendar may need more scrolling")
        markBtn.tap()
        sleep(1)

        // Day Complete overlay should appear
        let overlay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Day 1 Complete'")).firstMatch
        XCTAssertTrue(overlay.waitForExistence(timeout: 5), "Day Complete overlay must appear after completing Day 1")

        // Dismiss with "Continue Journey" button
        let continueBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch
        XCTAssertTrue(continueBtn.waitForExistence(timeout: 5))
        continueBtn.tap()
        sleep(1)
        print("✓ Dismissed overlay — Day 1 complete")
    }

    // MARK: - Phase 1: DayCompleteOverlay — streak pill and Continue button

    func test07_dayCompleteOverlay_showsStreakPill() throws {
        try test06_MarkDayComplete()

        // Mark Day 2 to verify streak pill increments
        app.swipeUp(); sleep(1)
        app.swipeUp(); sleep(1)
        let markBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'today complete'")).firstMatch
        XCTAssertTrue(markBtn.waitForExistence(timeout: 8), "Mark today complete must be visible after dismissing Day 1 overlay")
        markBtn.tap()
        sleep(1)

        let streakPill = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'streak'")
        ).firstMatch
        XCTAssertTrue(streakPill.waitForExistence(timeout: 5),
                      "DayCompleteOverlay must show a streak pill after day completion")

        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch
            .waitForExistence(timeout: 3)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch.tap()
    }

    func test08_dayCompleteOverlay_continueButtonDismissesOverlay() throws {
        try test05_StartJournalFromResults()

        app.swipeUp(); sleep(1)
        app.swipeUp(); sleep(1)
        let markBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'today complete'")).firstMatch
        XCTAssertTrue(markBtn.waitForExistence(timeout: 8))
        markBtn.tap()

        let overlay = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Complete!'")).firstMatch
        XCTAssertTrue(overlay.waitForExistence(timeout: 5), "Day Complete overlay must appear")

        let continueBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch
        XCTAssertTrue(continueBtn.waitForExistence(timeout: 3))
        continueBtn.tap()
        sleep(1)

        XCTAssertFalse(
            app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch.exists,
            "Tapping Continue Journey must dismiss the DayCompleteOverlay"
        )
    }

    func test09_dayCompleteOverlay_tomorrowsWisdomPreviewPresent() throws {
        try test05_StartJournalFromResults()

        app.swipeUp(); sleep(1)
        app.swipeUp(); sleep(1)
        let markBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'today complete'")).firstMatch
        XCTAssertTrue(markBtn.waitForExistence(timeout: 8))
        markBtn.tap()

        let wisdomLabel = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'wisdom'")
        ).firstMatch
        XCTAssertTrue(wisdomLabel.waitForExistence(timeout: 5),
                      "DayCompleteOverlay must show a 'Tomorrow's wisdom' quote preview")

        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch
            .waitForExistence(timeout: 3)
        app.buttons.matching(NSPredicate(format: "label CONTAINS 'Continue Journey'")).firstMatch.tap()
    }

    private func tapIfExists(_ label: String) {
        let el = app.buttons[label]
        if el.waitForExistence(timeout: 3) { el.tap() }
        else { print("⚠️ Button not found: \(label)") }
    }
}
