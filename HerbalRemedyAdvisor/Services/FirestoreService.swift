import FirebaseCore
import FirebaseCrashlytics
import FirebaseFirestore
import Foundation

final class FirestoreService {

    static let shared = FirestoreService()
    private init() {}

    private var db: Firestore? {
        guard FirebaseApp.app() != nil else { return nil }
        return Firestore.firestore()
    }

    // MARK: - User profile

    func saveUserProfile(uid: String, ageBracket: String, wellnessGoal: String) async throws {
        guard let db else { return }
        do {
            try await db.collection("users").document(uid).setData([
                "ageBracket":   ageBracket,
                "wellnessGoal": wellnessGoal,
                "createdAt":    FieldValue.serverTimestamp(),
            ])
        } catch {
            Crashlytics.crashlytics().record(error: error)
            throw error
        }
    }

    func fetchWellnessGoal(uid: String) async -> String? {
        guard let db else { return nil }
        let doc = try? await db.collection("users").document(uid).getDocument()
        return doc?.data()?["wellnessGoal"] as? String
    }
}
