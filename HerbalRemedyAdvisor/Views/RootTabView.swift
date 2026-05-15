import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var symptomVM: SymptomViewModel
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var traditionVM: TraditionViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            SymptomScreen(selectedTab: $selectedTab)
                .tabItem {
                    Label("Symptoms", systemImage: "")
                }
                .tag(0)

            NavigationStack {
                ResultsScreen()
            }
            .tabItem {
                Label("Remedies", systemImage: "")
            }
            .tag(1)

            TraditionFilterScreen(isStandaloneTab: true)
                .tabItem {
                    Label("Traditions", systemImage: "")
                }
                .tag(2)

            JournalScreen()
                .tabItem {
                    Label("Journal", systemImage: "")
                }
                .tag(3)
        }
        .onAppear { configureTabBar() }
        .accentColor(.gold)
        .onChange(of: journalVM.shouldNavigateToJournal) { requested in
            if requested {
                selectedTab = 3
                journalVM.shouldNavigateToJournal = false
            }
        }
    }

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.forest)

        let normal = UITabBarItemAppearance()
        normal.normal.iconColor = UIColor(Color.mist.opacity(0.4))
        normal.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.mist.opacity(0.4)),
            .font: UIFont(name: "NotoSans-Regular", size: 9) ?? UIFont.systemFont(ofSize: 9)
        ]
        normal.selected.iconColor = UIColor(Color.mist)
        normal.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.mist),
            .font: UIFont(name: "NotoSans-Regular", size: 9) ?? UIFont.systemFont(ofSize: 9)
        ]
        appearance.stackedLayoutAppearance = normal
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
