import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showDisclaimer = false
    @State private var showSignOutConfirm = false
    @State private var showDeleteConfirm = false

    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(v) (Beta Build \(b))"
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.forest.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Header
                    AppHeader(
                        icon: "leaf.fill",
                        label: "Nise",
                        title: "Settings & About",
                        subtitle: "Your account and app information"
                    )
                    .padding(.bottom, 8)

                    VStack(spacing: 24) {

                        // MARK: Our Story
                        card {
                            VStack(alignment: .leading, spacing: 0) {
                                sectionHeading("About")
                                    .padding(.bottom, 14)

                                Divider().background(Color.mist.opacity(0.15))

                                NavigationLink(destination: OurStoryView()) {
                                    HStack {
                                        Image(systemName: "heart.text.square")
                                            .font(.system(size: 15))
                                            .foregroundColor(.mist)
                                        Text("Our Story")
                                            .font(.notoSans(size: 15))
                                            .foregroundColor(.mist)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.mist.opacity(0.5))
                                    }
                                    .padding(.top, 16)
                                }
                            }
                        }

                        // MARK: Account
                        card {
                            VStack(alignment: .leading, spacing: 0) {
                                sectionHeading("Account")
                                    .padding(.bottom, 14)

                                Divider().background(Color.mist.opacity(0.15))

                                Button {
                                    showSignOutConfirm = true
                                } label: {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gold.opacity(0.85))
                                        Text("Sign Out")
                                            .font(.notoSans(size: 15))
                                            .foregroundColor(.gold.opacity(0.85))
                                        Spacer()
                                    }
                                    .padding(.top, 16)
                                }

                                Divider()
                                    .background(Color.mist.opacity(0.15))
                                    .padding(.top, 16)

                                Button {
                                    showDeleteConfirm = true
                                } label: {
                                    HStack {
                                        Image(systemName: "trash")
                                            .font(.system(size: 15))
                                            .foregroundColor(.red.opacity(0.75))
                                        Text("Delete Account")
                                            .font(.notoSans(size: 15))
                                            .foregroundColor(.red.opacity(0.75))
                                        Spacer()
                                    }
                                    .padding(.top, 16)
                                }

                                if let err = authVM.deleteError {
                                    Text(err)
                                        .font(.notoSans(size: 12))
                                        .foregroundColor(.gold)
                                        .padding(.top, 8)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .confirmationDialog("Sign out of Nise?",
                                            isPresented: $showSignOutConfirm,
                                            titleVisibility: .visible) {
                            Button("Sign Out", role: .destructive) { authVM.signOut() }
                            Button("Cancel", role: .cancel) {}
                        }
                        .confirmationDialog("Delete your account?",
                                            isPresented: $showDeleteConfirm,
                                            titleVisibility: .visible) {
                            Button("Delete Account", role: .destructive) { authVM.deleteAccount() }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("This permanently deletes your account and all data. This cannot be undone.")
                        }

                        // MARK: Legal
                        card {
                            VStack(alignment: .leading, spacing: 0) {
                                sectionHeading("Legal")
                                    .padding(.bottom, 14)

                                Divider().background(Color.mist.opacity(0.15))

                                Button {
                                    showDisclaimer = true
                                } label: {
                                    HStack {
                                        Image(systemName: "doc.text")
                                            .font(.system(size: 15))
                                            .foregroundColor(.mist)
                                        Text("Safety Disclaimer")
                                            .font(.notoSans(size: 15))
                                            .foregroundColor(.mist)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.mist.opacity(0.5))
                                    }
                                    .padding(.top, 16)
                                }

                                Divider().background(Color.mist.opacity(0.15)).padding(.top, 16)

                                Link(destination: URL(string: "https://nise.app/privacy")!) {
                                    HStack {
                                        Image(systemName: "hand.raised.fill")
                                            .font(.system(size: 15))
                                            .foregroundColor(.mist)
                                        Text("Privacy Policy")
                                            .font(.notoSans(size: 15))
                                            .foregroundColor(.mist)
                                        Spacer()
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.mist.opacity(0.5))
                                    }
                                    .padding(.top, 16)
                                }
                            }
                        }
                        .sheet(isPresented: $showDisclaimer) {
                            SafetyDisclaimerView()
                        }

                        // MARK: Footer
                        Text(appVersion)
                            .font(.notoSans(size: 11))
                            .foregroundColor(.mist.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                            .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.mist.opacity(0.12), lineWidth: 1)
            )
    }

    @ViewBuilder
    private func sectionHeading(_ text: String) -> some View {
        Text(text)
            .font(.notoSerif(size: 17, weight: .bold))
            .foregroundColor(.cream)
    }

}
