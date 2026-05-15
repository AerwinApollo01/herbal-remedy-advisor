import SwiftUI

@main
struct HerbalRemedyAdvisorApp: App {
    @StateObject private var symptomVM = SymptomViewModel()
    @StateObject private var journalVM = JournalViewModel()
    @StateObject private var traditionVM = TraditionViewModel()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(symptomVM)
                .environmentObject(journalVM)
                .environmentObject(traditionVM)
                .preferredColorScheme(.light)
        }
    }
}
