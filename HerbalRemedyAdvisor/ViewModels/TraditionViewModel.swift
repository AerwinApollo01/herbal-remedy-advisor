import Foundation

class TraditionViewModel: ObservableObject {
    @Published var selectedTraditionIds: Set<String> = []

    let traditions: [Tradition] = TraditionDatabase.all

    func toggle(_ tradition: Tradition) {
        if selectedTraditionIds.contains(tradition.id) {
            selectedTraditionIds.remove(tradition.id)
        } else {
            selectedTraditionIds.insert(tradition.id)
        }
    }

    func isSelected(_ tradition: Tradition) -> Bool {
        selectedTraditionIds.contains(tradition.id)
    }

    func clearAll() {
        selectedTraditionIds.removeAll()
    }
}
