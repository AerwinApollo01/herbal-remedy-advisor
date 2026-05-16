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
}
