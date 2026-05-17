import Foundation
import Combine

class JournalViewModel: ObservableObject {
    @Published var journalRecipe: Remedy?
    @Published var completedDays: [Int] = []
    @Published var completedProtocols: [String: Int] = [:]
    @Published var taskChecked: [Bool] = []
    @Published var protocolStartDate: Date?
    @Published var reminderOn: Bool = false
    @Published var reminderHour: Int = 7
    @Published var reminderMinute: Int = 30
    @Published var showNotificationDeniedAlert: Bool = false
    @Published var calYear: Int
    @Published var calMonth: Int
    @Published var selectedCalDay: SelectedCalDay?
    @Published var showDayOverlay: Bool = false
    @Published var showProtocolOverlay: Bool = false
    @Published var navigateToJournalTrigger: Int = 0

    // Prefix applied to all UserDefaults keys. Empty string = anonymous (pre-auth).
    // Set via configure(userID:) once the user signs in.
    private var keyPrefix: String = ""

    private let calendar = Calendar.current
    private static let iso8601 = ISO8601DateFormatter()

    init() {
        let now = Date()
        let comps = Calendar.current.dateComponents([.year, .month], from: now)
        calYear  = comps.year  ?? 2026
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
        if count == 0  { return "Begin your journey" }
        if count < 3   { return "You're getting started!" }
        if count < 7   { return "3-day streak — keep going!" }
        if count < 14  { return "One week strong" }
        return "Remarkable dedication"
    }

    var isProtocolComplete: Bool {
        guard let recipe = journalRecipe else { return false }
        return completedDays.count >= recipe.duration
    }

    func timesCompleted(remedy: Remedy) -> Int {
        completedProtocols[remedy.name] ?? 0
    }

    // MARK: - Actions

    func startJournal(remedy: Remedy, startDate: Date = Date()) {
        journalRecipe = remedy
        completedDays = []
        taskChecked = Array(repeating: false, count: remedy.steps.count)
        protocolStartDate = startDate
        reminderOn = false
        selectedCalDay = nil
        showDayOverlay = false
        showProtocolOverlay = false
        let comps = calendar.dateComponents([.year, .month], from: startDate)
        calYear  = comps.year  ?? calYear
        calMonth = (comps.month ?? 1) - 1
        persistState()
        navigateToJournalTrigger += 1
    }

    func completeDay() {
        guard let recipe = journalRecipe else { return }
        let nextDay = currentDayNumber
        if !completedDays.contains(nextDay) {
            completedDays.append(nextDay)
        }
        taskChecked = Array(repeating: false, count: recipe.steps.count)
        if completedDays.count >= recipe.duration {
            completedProtocols[recipe.name, default: 0] += 1
            showProtocolOverlay = true
            NotificationService.shared.cancel()
        } else {
            showDayOverlay = true
        }
        persistState()
    }

    func toggleTask(_ index: Int) {
        guard index < taskChecked.count else { return }
        taskChecked[index].toggle()
        persistState()
    }

    // Enables or disables the daily reminder. Requests notification permission
    // when turning on — sets showNotificationDeniedAlert if the user has blocked it.
    func setReminder(enabled: Bool) async {
        if enabled {
            let granted = await NotificationService.shared.requestAndSchedule(
                hour: reminderHour, minute: reminderMinute)
            await MainActor.run {
                if granted {
                    reminderOn = true
                } else {
                    showNotificationDeniedAlert = true
                }
                persistState()
            }
        } else {
            NotificationService.shared.cancel()
            await MainActor.run {
                reminderOn = false
                persistState()
            }
        }
    }

    // Reschedules the notification at a new time without changing the enabled state.
    func updateReminderTime(hour: Int, minute: Int) {
        reminderHour = hour
        reminderMinute = minute
        persistState()
        guard reminderOn else { return }
        Task { await NotificationService.shared.requestAndSchedule(hour: hour, minute: minute) }
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
        if calMonth == 0 { calMonth = 11; calYear -= 1 } else { calMonth -= 1 }
    }

    func nextMonth() {
        if calMonth == 11 { calMonth = 0; calYear += 1 } else { calMonth += 1 }
    }

    func selectCalendarDay(dayOfMonth: Int, protDayNum: Int) {
        if let existing = selectedCalDay,
           existing.dayOfMonth == dayOfMonth && existing.protDayNum == protDayNum {
            selectedCalDay = nil
        } else {
            selectedCalDay = SelectedCalDay(dayOfMonth: dayOfMonth, protDayNum: protDayNum)
        }
    }

    // MARK: - Auth / user configuration

    // Called by the App entry point once the user authenticates.
    // Migrates anonymous keys to user-prefixed keys (one-time), then reloads.
    func configure(userID: String) {
        JournalViewModel.migrateAnonymousKeys(to: userID)
        keyPrefix = "\(userID)_"
        loadPersistedState()
    }

    // MARK: - Persistence keys (prefix-aware)

    private var remedyNameKey:       String { "\(keyPrefix)journal_remedy_name" }
    private var completedDaysKey:    String { "\(keyPrefix)journal_completed_days" }
    private var completedProtoKey:   String { "\(keyPrefix)journal_completed_protocols" }
    private var startDateKey:        String { "\(keyPrefix)journal_start_date" }
    private var reminderOnKey:       String { "\(keyPrefix)journal_reminder_on" }
    private var reminderHourKey:     String { "\(keyPrefix)journal_reminder_hour" }
    private var reminderMinuteKey:   String { "\(keyPrefix)journal_reminder_minute" }
    private var taskCheckedKey:      String { "\(keyPrefix)journal_task_checked" }

    // MARK: - Persistence

    func persistState() {
        let d = UserDefaults.standard
        d.set(journalRecipe?.name, forKey: remedyNameKey)
        if let data = try? JSONEncoder().encode(completedDays) {
            d.set(data, forKey: completedDaysKey)
        }
        if let data = try? JSONEncoder().encode(completedProtocols) {
            d.set(data, forKey: completedProtoKey)
        }
        // ISO 8601 date string — immune to timezone shifts unlike TimeInterval.
        if let date = protocolStartDate {
            d.set(JournalViewModel.iso8601.string(from: date), forKey: startDateKey)
        }
        d.set(reminderOn, forKey: reminderOnKey)
        d.set(reminderHour, forKey: reminderHourKey)
        d.set(reminderMinute, forKey: reminderMinuteKey)
        if let data = try? JSONEncoder().encode(taskChecked) {
            d.set(data, forKey: taskCheckedKey)
        }
    }

    func loadPersistedState() {
        let d = UserDefaults.standard

        if let data = d.data(forKey: completedProtoKey),
           let counts = try? JSONDecoder().decode([String: Int].self, from: data) {
            completedProtocols = counts
        }

        guard let remedyName = d.string(forKey: remedyNameKey) else { return }
        let allRemedies: [Remedy] = RemedyDatabase.symptomMap.values.flatMap { $0 }
        guard let remedy = allRemedies.first(where: { $0.name == remedyName }) else { return }
        journalRecipe = remedy

        if let data = d.data(forKey: completedDaysKey),
           let days = try? JSONDecoder().decode([Int].self, from: data) {
            completedDays = days
        }

        // ISO 8601 date (current format). Falls back to TimeInterval for
        // data written before this migration was introduced.
        if let isoString = d.string(forKey: startDateKey) {
            protocolStartDate = JournalViewModel.iso8601.date(from: isoString)
        } else if let interval = d.object(forKey: startDateKey) as? Double {
            let date = Date(timeIntervalSince1970: interval)
            protocolStartDate = date
            d.set(JournalViewModel.iso8601.string(from: date), forKey: startDateKey)
        }

        reminderOn = d.bool(forKey: reminderOnKey)

        if let hour = d.object(forKey: reminderHourKey) as? Int {
            reminderHour = hour
        }
        if let minute = d.object(forKey: reminderMinuteKey) as? Int {
            reminderMinute = minute
        }

        if let data = d.data(forKey: taskCheckedKey),
           let checked = try? JSONDecoder().decode([Bool].self, from: data),
           checked.count == remedy.steps.count {
            taskChecked = checked
        } else {
            taskChecked = Array(repeating: false, count: remedy.steps.count)
        }
    }

    // MARK: - Migration: anonymous → user-prefixed keys

    // Runs once per userID. Copies all anonymous journal keys to user-prefixed
    // equivalents so progress from before auth was added is preserved.
    static func migrateAnonymousKeys(to userID: String) {
        let prefix = "\(userID)_"
        let guardKey = "\(prefix)journal_migration_complete"
        let d = UserDefaults.standard
        guard !d.bool(forKey: guardKey) else { return }

        let anonKeys = [
            "journal_remedy_name", "journal_completed_days",
            "journal_completed_protocols", "journal_start_date",
            "journal_reminder_on", "journal_reminder_hour", "journal_reminder_minute",
            "journal_task_checked"
        ]
        for key in anonKeys {
            if let value = d.object(forKey: key) {
                d.set(value, forKey: "\(prefix)\(key)")
                d.removeObject(forKey: key)
            }
        }
        d.set(true, forKey: guardKey)
    }

    // MARK: - Test support

    // Wipes anonymous-prefix keys. Pass a userID to also clear user-prefixed keys.
    static func clearPersistedState(userID: String? = nil) {
        let d = UserDefaults.standard
        let prefixes: [String] = userID.map { ["\($0)_", ""] } ?? [""]
        let baseKeys = [
            "journal_remedy_name", "journal_completed_days",
            "journal_completed_protocols", "journal_start_date",
            "journal_reminder_on", "journal_reminder_hour", "journal_reminder_minute",
            "journal_task_checked"
        ]
        for prefix in prefixes {
            baseKeys.forEach { d.removeObject(forKey: "\(prefix)\($0)") }
            d.removeObject(forKey: "\(prefix)journal_migration_complete")
        }
    }
}
