import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private let requestId = "nise.daily_reminder"
    private init() {}

    // Rotates through varied copy so the notification stays fresh beyond Day 4.
    private let notificationBodies: [String] = [
        "Time for today's herbal protocol. A small step toward balance.",
        "Your daily ritual is waiting. Even five minutes counts.",
        "Ancient wisdom, one day at a time. Ready when you are.",
        "Consistency is the protocol. Show up for today's practice.",
    ]

    private var nextBody: String {
        let day = Calendar.current.component(.weekday, from: Date()) - 1 // 0–6
        return notificationBodies[day % notificationBodies.count]
    }

    // Requests permission (if not yet determined) then schedules a repeating
    // daily notification. Returns false if the user has denied permission.
    func requestAndSchedule(hour: Int, minute: Int) async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .notDetermined:
            guard (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) == true
            else { return false }
        case .authorized, .provisional:
            break
        default:
            return false
        }

        center.removePendingNotificationRequests(withIdentifiers: [requestId])

        let content = UNMutableNotificationContent()
        content.title = "Your Daily Practice"
        content.body = nextBody
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        try? await center.add(request)
        return true
    }

    func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestId])
    }

    func authorizationStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }
}
