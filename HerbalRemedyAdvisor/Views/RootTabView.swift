import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var symptomVM: SymptomViewModel
    @EnvironmentObject var journalVM: JournalViewModel
    @EnvironmentObject var traditionVM: TraditionViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            SymptomScreen(selectedTab: $selectedTab)
                .tabItem {
                    Label("Symptoms", systemImage: "waveform.path.ecg")
                }
                .tag(0)

            NavigationStack {
                ResultsScreen(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Remedies", systemImage: "leaf.fill")
            }
            .tag(1)

            NavigationStack {
                TraditionFilterScreen(isStandaloneTab: true)
                    .navigationDestination(for: Tradition.self) { tradition in
                        TraditionDetailScreen(tradition: tradition)
                    }
            }
            .tabItem {
                Label("Traditions", systemImage: "globe.americas.fill")
            }
            .tag(2)

            JournalScreen()
                .tabItem {
                    Label("Journal", systemImage: "book.closed.fill")
                }
                .tag(3)

            NavigationStack {
                SettingsScreen()
            }
            .tabItem {
                Label("About", systemImage: "leaf.circle.fill")
            }
            .tag(4)
        }
        .onAppear { configureTabBar() }
        .accentColor(.gold)
        .onChange(of: journalVM.navigateToJournalTrigger) { _ in
            selectedTab = 3
        }
    }

    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.forest)

        let normal = UITabBarItemAppearance()
        normal.normal.iconColor = UIColor(Color.mist.opacity(0.7))
        normal.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.mist.opacity(0.7)),
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
