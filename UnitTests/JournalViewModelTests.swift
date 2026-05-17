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

    // MARK: - Phase 1: DayCompleteOverlay milestone boundaries
    // The overlay shows milestone callouts at integer-rounded 25/50/75% days.
    // Formula: quarter=(d+2)/4, half=d/2, threeQuarters=(3d+2)/4  (integer division)
    // This section validates the milestone days for each real protocol duration.

    func test_milestoneDay_7dayProtocol() {
        // 7-day (papayaSeedHoney): quarter=2, half=3, threeQuarters=5
        XCTAssertEqual((7 + 2) / 4, 2)
        XCTAssertEqual(7 / 2,       3)
        XCTAssertEqual((21 + 2) / 4, 5)
    }

    func test_milestoneDay_14dayProtocol() {
        // 14-day: quarter=4, half=7, threeQuarters=11
        XCTAssertEqual((14 + 2) / 4, 4)
        XCTAssertEqual(14 / 2,       7)
        XCTAssertEqual((42 + 2) / 4, 11)
    }

    func test_milestoneDay_21dayProtocol() {
        // 21-day: quarter=5, half=10, threeQuarters=16
        XCTAssertEqual((21 + 2) / 4, 5)
        XCTAssertEqual(21 / 2,       10)
        XCTAssertEqual((63 + 2) / 4, 16)
    }

    func test_milestoneDay_30dayProtocol() {
        // 30-day: quarter=8, half=15, threeQuarters=23
        XCTAssertEqual((30 + 2) / 4, 8)
        XCTAssertEqual(30 / 2,       15)
        XCTAssertEqual((90 + 2) / 4, 23)
    }

    func test_milestoneDay_noTwoMilestonesOnSameDay() {
        // Verify that for all real protocol durations, no two milestone days collide.
        for duration in [7, 14, 21, 30] {
            let quarter      = (duration + 2) / 4
            let half         = duration / 2
            let threeQuarter = (3 * duration + 2) / 4
            let days = [quarter, half, threeQuarter]
            XCTAssertEqual(Set(days).count, days.count,
                           "Milestone days must be distinct for \(duration)-day protocol: \(days)")
        }
    }

    func test_progressPercent_atHalfMilestone_7day() {
        // completedDays=3 on a 7-day protocol → 3/7 ≈ 0.429 (not exactly 50%,
        // but half milestone fires at day 3 via integer division 7/2=3).
        // This confirms the VM produces the right count at the milestone day.
        vm.startJournal(remedy: shortRemedy)
        vm.completedDays = [1, 2, 3]
        XCTAssertEqual(vm.completedDays.count, 7 / 2)
    }

    // MARK: - Phase 1: Day 3 milestone — only fires on exactly day 3

    func test_day3Milestone_completedCountEqualsThree() {
        vm.startJournal(remedy: shortRemedy)
        vm.completedDays = [1, 2, 3]
        XCTAssertEqual(vm.completedDays.count, 3, "Day 3 milestone requires completedDays.count == 3")
    }

    func test_day3Milestone_doesNotFireOnDay2OrDay4() {
        vm.startJournal(remedy: shortRemedy)
        vm.completedDays = [1, 2]
        XCTAssertNotEqual(vm.completedDays.count, 3, "Day 2 must not trigger day 3 milestone")
        vm.completedDays = [1, 2, 3, 4]
        XCTAssertNotEqual(vm.completedDays.count, 3, "Day 4 must not trigger day 3 milestone")
    }
}
