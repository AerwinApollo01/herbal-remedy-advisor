import XCTest
@testable import HerbalRemedyAdvisor

final class RemedyDatabaseTests: XCTestCase {

    // MARK: - Symptom lookup

    func test_singleSymptomReturnsRemedies() {
        let results = RemedyDatabase.remedies(for: ["Bloating & Gas"])
        XCTAssertFalse(results.isEmpty, "Bloating & Gas should have at least one remedy")
    }

    func test_multipleSymptomsMergeWithoutDuplicates() {
        let single = RemedyDatabase.remedies(for: ["Bloating & Gas"])
        let multi  = RemedyDatabase.remedies(for: ["Bloating & Gas", "Fatigue"])
        XCTAssertGreaterThan(multi.count, single.count, "Adding a second symptom should increase remedy count")
        let names = multi.map { $0.name }
        XCTAssertEqual(names.count, Set(names).count, "Results must not contain duplicates")
    }

    func test_unknownSymptomReturnsEmpty() {
        let results = RemedyDatabase.remedies(for: ["Completely Unknown Symptom XYZ"])
        XCTAssertTrue(results.isEmpty, "Unknown symptoms should return zero remedies")
    }

    func test_emptySymptomSetReturnsEmpty() {
        let results = RemedyDatabase.remedies(for: [])
        XCTAssertTrue(results.isEmpty, "Empty symptom set should return zero remedies")
    }

    func test_allKnownSymptomsHaveRemedies() {
        let symptoms = [
            "Bloating & Gas", "Fatigue", "Digestive Issues", "Skin Irritation",
            "Brain Fog", "Sugar Cravings", "Joint Discomfort", "Sleep Issues",
            "Appetite Loss", "Mood Changes"
        ]
        for symptom in symptoms {
            let results = RemedyDatabase.remedies(for: [symptom])
            XCTAssertFalse(results.isEmpty, "\(symptom) should have at least one remedy")
        }
    }

    // MARK: - Tradition lookup

    func test_traditionLookupByTid() {
        let results = RemedyDatabase.remedies(for: "ayurveda")
        XCTAssertFalse(results.isEmpty, "Ayurveda should have remedies")
        XCTAssertTrue(results.allSatisfy { $0.tid == "ayurveda" }, "All results should belong to ayurveda")
    }

    func test_traditionLookupNoDuplicates() {
        let results = RemedyDatabase.remedies(for: "euro")
        let names = results.map { $0.name }
        XCTAssertEqual(names.count, Set(names).count, "Tradition results must not contain duplicates")
    }

    func test_unknownTidReturnsEmpty() {
        let results = RemedyDatabase.remedies(for: "nonexistent_tid_xyz")
        XCTAssertTrue(results.isEmpty, "Unknown tradition id should return zero remedies")
    }

    func test_allKnownTraditionsHaveRemedies() {
        let tids = ["ayurveda", "tcm", "persian", "folk", "euro"]
        for tid in tids {
            let results = RemedyDatabase.remedies(for: tid)
            XCTAssertFalse(results.isEmpty, "Tradition '\(tid)' should have at least one remedy")
        }
    }

    // MARK: - Remedy data integrity

    func test_allRemediesHaveNonEmptySteps() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertFalse(remedy.steps.isEmpty, "\(remedy.name) must have at least one step")
        }
    }

    func test_allRemediesHavePositiveDuration() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertGreaterThan(remedy.duration, 0, "\(remedy.name) must have duration > 0")
        }
    }

    func test_allRemediesHaveValidTid() {
        let validTids = Set(TraditionDatabase.all.map { $0.id })
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertTrue(validTids.contains(remedy.tid),
                          "\(remedy.name) has unknown tid '\(remedy.tid)'")
        }
    }

    func test_remedySfSymbolNeverEmpty() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertFalse(remedy.sfSymbol.isEmpty, "\(remedy.name) sfSymbol must not be empty")
        }
    }

    // MARK: - Phase 2: IngredientDetail + disclaimer + citations data integrity

    func test_allRemediesHaveIngredientDetails() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertFalse(remedy.ingredientDetails.isEmpty,
                           "\(remedy.name) must have at least one IngredientDetail")
        }
    }

    func test_ingredientDetailsMatchIngredientNames() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertEqual(remedy.ingredients, remedy.ingredientDetails.map(\.name),
                           "\(remedy.name): ingredients computed property must match ingredientDetails names")
        }
    }

    func test_allRemediesHaveNonEmptyDisclaimer() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertFalse(remedy.disclaimer.isEmpty,
                           "\(remedy.name) must have a non-empty disclaimer")
        }
    }

    func test_allRemediesHaveCitations() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            XCTAssertFalse(remedy.citations.isEmpty,
                           "\(remedy.name) must have at least one citation")
        }
    }

    func test_allCitationsHaveNonEmptyURLs() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            for citation in remedy.citations {
                XCTAssertFalse(citation.url.isEmpty,
                               "\(remedy.name) citation '\(citation.text.prefix(40))...' must have a non-empty URL")
                XCTAssertNotNil(URL(string: citation.url),
                                "\(remedy.name) citation URL '\(citation.url)' must be a valid URL")
            }
        }
    }

    func test_ingredientDetailIDsAreUniquePerRemedy() {
        let all = RemedyDatabase.symptomMap.values.flatMap { $0 }
        for remedy in all {
            let ids = remedy.ingredientDetails.map(\.id)
            XCTAssertEqual(ids.count, Set(ids).count,
                           "\(remedy.name) has duplicate ingredient names (IngredientDetail.id must be unique per remedy)")
        }
    }

    // MARK: - Phase 2: New traditions

    func test_africanHerbalismTidHasRemedies() {
        let results = RemedyDatabase.remedies(for: "african")
        XCTAssertFalse(results.isEmpty, "African Herbalism should have remedies")
        XCTAssertTrue(results.allSatisfy { $0.tid == "african" },
                      "All african results should have tid 'african'")
    }

    func test_africanHerbalismHasAtLeastThreeRemedies() {
        let results = RemedyDatabase.remedies(for: "african")
        XCTAssertGreaterThanOrEqual(results.count, 3,
                                    "African Herbalism should have at least 3 remedies")
    }

    func test_persianMedicineHasAtLeastThreeRemedies() {
        let results = RemedyDatabase.remedies(for: "persian")
        XCTAssertGreaterThanOrEqual(results.count, 3,
                                    "Persian Medicine should have at least 3 remedies")
    }

    // MARK: - Phase 2: Wellness goal weighting (SymptomViewModel)

    func test_wellnessGoalBoost_digestiveHealth_prioritizesDigestiveRemedies() {
        let vm = SymptomViewModel()
        vm.wellnessGoal = "Digestive Health"
        vm.selectedSymptoms = ["Bloating & Gas", "Fatigue"]
        vm.analyzeSymptoms()
        // Wait for the 2-second async delay
        let expectation = XCTestExpectation(description: "analyzeSymptoms completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { expectation.fulfill() }
        wait(for: [expectation], timeout: 4)

        guard let first = vm.matchedRemedies.first else {
            XCTFail("Must return at least one remedy")
            return
        }
        let digestiveSymptoms: Set<String> = ["Digestive Issues", "Bloating & Gas", "Appetite Loss"]
        let firstIsDigestive = RemedyDatabase.symptomMap.contains { key, vals in
            digestiveSymptoms.contains(key) && vals.contains(first)
        }
        XCTAssertTrue(firstIsDigestive,
                      "With Digestive Health goal, first result should be a digestive remedy; got \(first.name)")
    }

    func test_noWellnessGoal_returnsUnweightedOrder() {
        let vm = SymptomViewModel()
        vm.wellnessGoal = nil
        vm.selectedSymptoms = ["Bloating & Gas"]
        vm.analyzeSymptoms()
        let expectation = XCTestExpectation(description: "analyzeSymptoms completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { expectation.fulfill() }
        wait(for: [expectation], timeout: 4)
        XCTAssertFalse(vm.matchedRemedies.isEmpty,
                       "No-goal analysis must still return remedies")
    }
}
