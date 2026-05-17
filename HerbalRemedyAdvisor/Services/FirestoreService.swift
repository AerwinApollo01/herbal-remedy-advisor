import FirebaseCore
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
        try await db.collection("users").document(uid).setData([
            "ageBracket":   ageBracket,
            "wellnessGoal": wellnessGoal,
            "createdAt":    FieldValue.serverTimestamp(),
        ])
    }
}
