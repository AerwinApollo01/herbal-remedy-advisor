import XCTest
@testable import HerbalRemedyAdvisor

final class JournalViewModelTests: XCTestCase {

    private var vm: JournalViewModel!
    private let shortRemedy = RemedyDatabase.papayaSeedHoney // duration = 7

    private let persistenceKeys = [
        "journal_remedy_name",
        "journal_completed_days",
        "journal_completed_protocols",
        "journal_start_date",
        "journal_reminder_on"
    ]

    override func setUp() {
        super.setUp()
        // Clean BEFORE creating JournalViewModel so init() loads a blank slate
        persistenceKeys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        vm = JournalViewModel()
    }

    override func tearDown() {
        // Clean AFTER each test so the next setUp starts from a known state
        persistenceKeys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        vm = nil
        super.tearDown()
    }

    // MARK: - startJournal

    func test_startJournal_setsRecipe() {
        vm.startJournal(remedy: shortRemedy)
        XCTAssertEqual(vm.journalRecipe?.name, shortRemedy.name)
    }

    func test_startJournal_resetsDays() {
        vm.startJournal(remedy: shortRemedy)
        vm.completeDay()
        vm.startJournal(remedy: shortRemedy)
        XCTAssertTrue(vm.completedDays.isEmpty, "startJournal must reset completedDays")
    }

    func test_startJournal_doesNotResetCompletedProtocols() {
        vm.startJournal(remedy: shortRemedy)
        vm.completedProtocols[shortRemedy.name] = 2
        vm.startJournal(remedy: shortRemedy)
        XCTAssertEqual(vm.completedProtocols[shortRemedy.name], 2,
                       "startJournal must not erase lifetime completion counts")
    }

    // MARK: - completeDay

    func test_completeDay_incrementsCount() {
        vm.startJournal(remedy: shortRemedy)
        vm.completeDay()
        XCTAssertEqual(vm.completedDays.count, 1)
    }

    func test_completeDay_eachCallAdvancesToNextDay() {
        // Each call to completeDay() adds the NEXT protocol day (currentDayNumber advances).
        // The dedup guard (contains check) protects against the same day being added twice
        // in a concurrent scenario — not against sequential calls which move to the next day.
        vm.startJournal(remedy: shortRemedy)
        vm.showDayOverlay = false
        vm.completeDay() // adds day 1
        vm.showDayOverlay = false
        vm.completeDay() // adds day 2
        XCTAssertEqual(vm.completedDays, [1, 2])
    }

    func test_completeDay_doesNotDuplicateIfSameDayForced() {
        // Simulate a scenario where completedDays already contains the current day
        vm.startJournal(remedy: shortRemedy)
        vm.completedDays = [1, 2, 3] // manually set — currentDayNumber becomes 4
        vm.completedDays.append(4)   // pre-add day 4
        let before = vm.completedDays.count
        vm.completeDay()             // completeDay would try to add 5, not 4
        // The guard only protects the CURRENT nextDay from being added twice
        XCTAssertEqual(vm.completedDays.count, before + 1)
        XCTAssertEqual(Set(vm.completedDays).count, vm.completedDays.count, "No duplicate days")
    }

    func test_completeDay_showsDayOverlayBeforeFinish() {
        vm.startJournal(remedy: shortRemedy)
        vm.completeDay()
        XCTAssertTrue(vm.showDayOverlay)
        XCTAssertFalse(vm.showProtocolOverlay)
    }

    func test_completeDay_showsProtocolOverlayOnFinish() {
        vm.startJournal(remedy: shortRemedy)
        for _ in 1...shortRemedy.duration {
            vm.showDayOverlay = false
            vm.completeDay()
        }
        XCTAssertTrue(vm.showProtocolOverlay, "Protocol overlay must show when all days completed")
        XCTAssertFalse(vm.showDayOverlay)
    }

    // MARK: - Protocol completion counter

    func test_completedProtocolsIncrementedOnFinish() {
        vm.startJournal(remedy: shortRemedy)
        for _ in 1...shortRemedy.duration {
            vm.showDayOverlay = false
            vm.completeDay()
        }
        XCTAssertEqual(vm.timesCompleted(remedy: shortRemedy), 1,
                       "timesCompleted must be 1 after first full protocol")
    }

    func test_completedProtocolsAccumulateAcrossRuns() {
        for _ in 1...2 {
            vm.startJournal(remedy: shortRemedy)
            for _ in 1...shortRemedy.duration {
                vm.showDayOverlay = false
                vm.completeDay()
            }
            vm.showProtocolOverlay = false
        }
        XCTAssertEqual(vm.timesCompleted(remedy: shortRemedy), 2,
                       "Lifetime count must accumulate across protocol restarts")
    }

    func test_timesCompleted_zeroForFreshVM() {
        vm.startJournal(remedy: shortRemedy)
        XCTAssertEqual(vm.timesCompleted(remedy: shortRemedy), 0)
    }

    // MARK: - Computed properties

    func test_currentDayNumberStartsAtOne() {
        vm.startJournal(remedy: shortRemedy)
        XCTAssertEqual(vm.currentDayNumber, 1)
    }

    func test_currentDayNumberAdvancesAfterCompletion() {
        vm.startJournal(remedy: shortRemedy)
        vm.completeDay()
        XCTAssertEqual(vm.currentDayNumber, 2)
    }

    func test_progressPercentZeroAtStart() {
        vm.startJournal(remedy: shortRemedy)
        XCTAssertEqual(vm.progressPercent, 0.0, accuracy: 0.001)
    }

    func test_progressPercentOneHundredWhenComplete() {
        vm.startJournal(remedy: shortRemedy)
        for _ in 1...shortRemedy.duration {
            vm.showDayOverlay = false
            vm.completeDay()
        }
        XCTAssertEqual(vm.progressPercent, 1.0, accuracy: 0.001)
    }

    func test_daysLeftDecreasesWithCompletion() {
        vm.startJournal(remedy: shortRemedy)
        let initial = vm.daysLeft
        vm.completeDay()
        XCTAssertEqual(vm.daysLeft, initial - 1)
    }

    func test_isProtocolCompleteReturnsFalseAtStart() {
        vm.startJournal(remedy: shortRemedy)
        XCTAssertFalse(vm.isProtocolComplete)
    }

    func test_isProtocolCompleteReturnsTrueWhenDone() {
        vm.startJournal(remedy: shortRemedy)
        for _ in 1...shortRemedy.duration {
            vm.showDayOverlay = false
            vm.completeDay()
        }
        XCTAssertTrue(vm.isProtocolComplete)
    }
}
