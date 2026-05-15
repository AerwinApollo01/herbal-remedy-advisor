import Foundation
import Combine

class JournalViewModel: ObservableObject {
    @Published var journalRecipe: Remedy?
    @Published var completedDays: [Int] = []
    @Published var taskChecked: [Bool] = []
    @Published var protocolStartDate: Date?
    @Published var reminderOn: Bool = true
    @Published var calYear: Int
    @Published var calMonth: Int
    @Published var selectedCalDay: SelectedCalDay?
    @Published var showDayOverlay: Bool = false
    @Published var showProtocolOverlay: Bool = false

    private let calendar = Calendar.current

    init() {
        let now = Date()
        let comps = Calendar.current.dateComponents([.year, .month], from: now)
        calYear = comps.year ?? 2026
        calMonth = (comps.month ?? 1) - 1
        loadPersistedState()
    }

    // MARK: - Computed

    var currentDayNumber: Int { completedDays.count + 1 }

    var progressPercent: Double {
        guard let recipe = journalRecipe, recipe.duration > 0 else { return 0 }
        return Double(completedDays.count) / Double(recipe.duration)
    }

    var daysLeft: Int {
        guard let recipe = journalRecipe else { return 0 }
        return max(0, recipe.duration - completedDays.count)
    }

    var streakLabel: String {
        let count = completedDays.count
        if count == 0 { return "Begin your journey" }
        if count < 3 { return "You're getting started!" }
        if count < 7 { return "3-day streak — keep going!" }
        if count < 14 { return "One week strong 🌱" }
        return "Remarkable dedication 🌿"
    }

    var isProtocolComplete: Bool {
        guard let recipe = journalRecipe else { return false }
        return completedDays.count >= recipe.duration
    }

    // MARK: - Actions

    func startJournal(remedy: Remedy, startDate: Date = Date()) {
        journalRecipe = remedy
        completedDays = []
        taskChecked = Array(repeating: false, count: remedy.steps.count)
        protocolStartDate = startDate
        reminderOn = true
        selectedCalDay = nil
        showDayOverlay = false
        showProtocolOverlay = false
        let comps = calendar.dateComponents([.year, .month], from: startDate)
        calYear = comps.year ?? calYear
        calMonth = (comps.month ?? 1) - 1
        persistState()
    }

    func completeDay() {
        guard let recipe = journalRecipe else { return }
        let nextDay = currentDayNumber
        if !completedDays.contains(nextDay) {
            completedDays.append(nextDay)
        }
        taskChecked = Array(repeating: false, count: recipe.steps.count)
        if completedDays.count >= recipe.duration {
            showProtocolOverlay = true
        } else {
            showDayOverlay = true
        }
        persistState()
    }

    func toggleTask(_ index: Int) {
        guard index < taskChecked.count else { return }
        taskChecked[index].toggle()
    }

    func getQuote(for dayNum: Int) -> Quote {
        guard let tid = journalRecipe?.tid else {
            return Quote(q: "Let food be thy medicine.", a: "Hippocrates", c: "")
        }
        return QuoteDatabase.quote(for: tid, dayNumber: dayNum)
    }

    func protocolDayNumber(for date: Date) -> Int? {
        guard let start = protocolStartDate, let recipe = journalRecipe else { return nil }
        let diff = calendar.dateComponents([.day], from: start, to: date).day ?? -1
        guard diff >= 0 && diff < recipe.duration else { return nil }
        return diff + 1
    }

    func prevMonth() {
        if calMonth == 0 {
            calMonth = 11
            calYear -= 1
        } else {
            calMonth -= 1
        }
    }

    func nextMonth() {
        if calMonth == 11 {
            calMonth = 0
            calYear += 1
        } else {
            calMonth += 1
        }
    }

    func selectCalendarDay(dayOfMonth: Int, protDayNum: Int) {
        if let existing = selectedCalDay,
           existing.dayOfMonth == dayOfMonth && existing.protDayNum == protDayNum {
            selectedCalDay = nil
        } else {
            selectedCalDay = SelectedCalDay(dayOfMonth: dayOfMonth, protDayNum: protDayNum)
        }
    }

    // MARK: - Persistence

    private enum Keys {
        static let remedyName = "journal_remedy_name"
        static let completedDays = "journal_completed_days"
        static let startDate = "journal_start_date"
        static let reminderOn = "journal_reminder_on"
    }

    func persistState() {
        let defaults = UserDefaults.standard
        defaults.set(journalRecipe?.name, forKey: Keys.remedyName)
        if let data = try? JSONEncoder().encode(completedDays) {
            defaults.set(data, forKey: Keys.completedDays)
        }
        if let date = protocolStartDate {
            defaults.set(date.timeIntervalSince1970, forKey: Keys.startDate)
        }
        defaults.set(reminderOn, forKey: Keys.reminderOn)
    }

    func loadPersistedState() {
        let defaults = UserDefaults.standard
        guard let remedyName = defaults.string(forKey: Keys.remedyName) else { return }

        // Find the remedy by name from all known remedies
        let allRemedies: [Remedy] = RemedyDatabase.symptomMap.values.flatMap { $0 }
        guard let remedy = allRemedies.first(where: { $0.name == remedyName }) else { return }
        journalRecipe = remedy

        if let data = defaults.data(forKey: Keys.completedDays),
           let days = try? JSONDecoder().decode([Int].self, from: data) {
            completedDays = days
        }
        if let interval = defaults.object(forKey: Keys.startDate) as? Double {
            protocolStartDate = Date(timeIntervalSince1970: interval)
        }
        reminderOn = defaults.bool(forKey: Keys.reminderOn)
        taskChecked = Array(repeating: false, count: remedy.steps.count)
    }
}
