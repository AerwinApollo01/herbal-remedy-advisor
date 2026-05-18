import Foundation
import Combine

class SymptomViewModel: ObservableObject {
    @Published var selectedSymptoms: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var matchedRemedies: [Remedy] = []
    @Published var showAlert: Bool = false
    @Published var wellnessGoal: String?

    let allSymptoms: [String] = [
        "Bloating & Gas",
        "Fatigue",
        "Digestive Issues",
        "Skin Irritation",
        "Brain Fog",
        "Sugar Cravings",
        "Joint Discomfort",
        "Sleep Issues",
        "Appetite Loss",
        "Mood Changes"
    ]

    // Maps each onboarding wellness goal to the symptom categories it boosts in results.
    private static let goalSymptomBoost: [String: Set<String>] = [
        "Digestive Health":  ["Digestive Issues", "Bloating & Gas", "Appetite Loss"],
        "Stress & Sleep":    ["Sleep Issues", "Mood Changes", "Fatigue"],
        "Immune Support":    ["Fatigue", "Skin Irritation"],
        "Energy & Vitality": ["Fatigue", "Brain Fog"],
        "Detox & Cleanse":   ["Digestive Issues", "Bloating & Gas", "Skin Irritation"],
        "Skin Health":       ["Skin Irritation"],
    ]

    func toggleSymptom(_ symptom: String) {
        if selectedSymptoms.contains(symptom) {
            selectedSymptoms.remove(symptom)
        } else {
            selectedSymptoms.insert(symptom)
        }
    }

    func analyzeSymptoms() {
        guard !selectedSymptoms.isEmpty else {
            showAlert = true
            return
        }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self else { return }
            var remedies = RemedyDatabase.remedies(for: self.selectedSymptoms)
            if let goal = self.wellnessGoal,
               let boostSymptoms = Self.goalSymptomBoost[goal],
               !boostSymptoms.isEmpty {
                remedies.sort { a, b in
                    let aGoalRelevant = RemedyDatabase.symptomMap.contains { key, vals in
                        boostSymptoms.contains(key) && vals.contains(a)
                    }
                    let bGoalRelevant = RemedyDatabase.symptomMap.contains { key, vals in
                        boostSymptoms.contains(key) && vals.contains(b)
                    }
                    return aGoalRelevant && !bGoalRelevant
                }
            }
            self.matchedRemedies = remedies
            self.isLoading = false
        }
    }
}
