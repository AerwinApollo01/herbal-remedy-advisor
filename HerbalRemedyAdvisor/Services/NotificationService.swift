import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private let requestId = "nise.daily_reminder"
    private init() {}

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
        content.body = "Time for today's herbal protocol. A small step toward balance."
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
