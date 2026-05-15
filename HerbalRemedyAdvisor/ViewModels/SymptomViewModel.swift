import Foundation
import Combine

class SymptomViewModel: ObservableObject {
    @Published var selectedSymptoms: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var matchedRemedies: [Remedy] = []
    @Published var showAlert: Bool = false

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
            self.matchedRemedies = RemedyDatabase.remedies(for: self.selectedSymptoms)
            self.isLoading = false
        }
    }
}
