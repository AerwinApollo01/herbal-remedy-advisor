import XCTest
@testable import HerbalRemedyAdvisor

final class TraditionViewModelTests: XCTestCase {

    private var vm: TraditionViewModel!
    private var ayurveda: Tradition { TraditionDatabase.all.first { $0.id == "ayurveda" }! }
    private var tcm: Tradition      { TraditionDatabase.all.first { $0.id == "tcm" }! }

    override func setUp() {
        super.setUp()
        vm = TraditionViewModel()
    }

    // MARK: - Initial state

    func test_initialSelectionIsEmpty() {
        XCTAssertTrue(vm.selectedTraditionIds.isEmpty)
    }

    func test_allTraditionsLoaded() {
        XCTAssertEqual(vm.traditions.count, TraditionDatabase.all.count)
        XCTAssertGreaterThan(vm.traditions.count, 0)
    }

    // MARK: - toggle

    func test_toggleSelectsTradition() {
        vm.toggle(ayurveda)
        XCTAssertTrue(vm.isSelected(ayurveda))
    }

    func test_toggleDeselectsTradition() {
        vm.toggle(ayurveda)
        vm.toggle(ayurveda)
        XCTAssertFalse(vm.isSelected(ayurveda))
    }

    func test_toggleMultipleTraditionsIndependently() {
        vm.toggle(ayurveda)
        vm.toggle(tcm)
        XCTAssertTrue(vm.isSelected(ayurveda))
        XCTAssertTrue(vm.isSelected(tcm))
        XCTAssertEqual(vm.selectedTraditionIds.count, 2)
    }

    // MARK: - clearAll

    func test_clearAllRemovesAllSelections() {
        vm.toggle(ayurveda)
        vm.toggle(tcm)
        vm.clearAll()
        XCTAssertTrue(vm.selectedTraditionIds.isEmpty)
        XCTAssertFalse(vm.isSelected(ayurveda))
        XCTAssertFalse(vm.isSelected(tcm))
    }

    func test_clearAllOnEmptyIsNoOp() {
        XCTAssertNoThrow(vm.clearAll())
        XCTAssertTrue(vm.selectedTraditionIds.isEmpty)
    }

    // MARK: - TraditionDatabase integrity

    func test_allTraditionsHaveUniqueIds() {
        let ids = TraditionDatabase.all.map { $0.id }
        XCTAssertEqual(ids.count, Set(ids).count, "Tradition ids must be unique")
    }

    func test_traditionLookupById() {
        for tradition in TraditionDatabase.all {
            let found = TraditionDatabase.tradition(for: tradition.id)
            XCTAssertNotNil(found, "tradition(for:) must return a result for every known id")
            XCTAssertEqual(found?.id, tradition.id)
        }
    }

    func test_unknownTidReturnsNil() {
        XCTAssertNil(TraditionDatabase.tradition(for: "totally_unknown_xyz"))
    }

    func test_allTraditionsHaveNonEmptyName() {
        for t in TraditionDatabase.all {
            XCTAssertFalse(t.name.isEmpty, "Tradition id '\(t.id)' must have a non-empty name")
        }
    }

    func test_allTraditionsHaveNonEmptySfSymbol() {
        for t in TraditionDatabase.all {
            XCTAssertFalse(t.sfSymbol.isEmpty, "Tradition '\(t.id)' must have a non-empty sfSymbol")
        }
    }
}
