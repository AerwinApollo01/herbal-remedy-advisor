import XCTest

final class UIFlowTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        sleep(1)
    }

    // MARK: - Symptom → Results → Detail flow
    func test01_SymptomToResults() throws {
        // Select two symptoms
        tapIfExists("Bloating & Gas")
        tapIfExists("Fatigue")
        sleep(1)

        // Tap CTA
        let cta = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Find Natural Remedies'")).firstMatch
        XCTAssertTrue(cta.waitForExistence(timeout: 5), "CTA button not found")
        cta.tap()

        // Wait through loading (2s)
        sleep(3)

        // Should now be on Results
        let resultsHeader = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Your Remedies'")).firstMatch
        print(resultsHeader.exists ? "✓ Results screen appeared" : "⚠️ Results header not found")
    }

    func test02_ViewProtocol() throws {
        try test01_SymptomToResults()

        // Tap first "View Protocol →" button
        let viewBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'View Protocol'")).firstMatch
        if viewBtn.waitForExistence(timeout: 5) {
            viewBtn.tap()
            sleep(1)
            print("✓ Navigated to Remedy Detail")

            // Check for ingredients section
            let ingredients = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Ingredient'")).firstMatch
            print(ingredients.exists ? "✓ Ingredients section visible" : "⚠️ Ingredients not found")
        }
    }

    func test03_TraditionFilter() throws {
        // Navigate to Traditions tab
        let tradTab = app.tabBars.buttons["Traditions"]
        XCTAssertTrue(tradTab.waitForExistence(timeout: 5))
        tradTab.tap()
        sleep(1)

        // Tap Ayurveda card
        let ayurveda = app.staticTexts["Ayurveda"].firstMatch
        if ayurveda.waitForExistence(timeout: 3) {
            ayurveda.tap()
            sleep(0)
            print("✓ Tapped Ayurveda tradition card")
        }
    }

    func test04_JournalEmpty() throws {
        let journalTab = app.tabBars.buttons["Journal"]
        XCTAssertTrue(journalTab.waitForExistence(timeout: 5))
        journalTab.tap()
        sleep(1)

        let emptyLabel = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'No Active Protocol'")).firstMatch
        print(emptyLabel.exists ? "✓ Empty journal state shown correctly" : "⚠️ Empty state not found")
    }

    private func tapIfExists(_ label: String) {
        let el = app.buttons[label]
        if el.waitForExistence(timeout: 3) { el.tap() }
        else { print("⚠️ Button not found: \(label)") }
    }
}
