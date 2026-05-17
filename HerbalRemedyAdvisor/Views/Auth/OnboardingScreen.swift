import SwiftUI

struct OnboardingScreen: View {
    @EnvironmentObject var authVM: AuthViewModel

    let userID: String
    let displayName: String?

    // MARK: - Options

    private let ageBrackets = ["Under 18", "18–29", "30–44", "45–59", "60 and over"]

    private let wellnessGoals = [
        "Digestive Health", "Stress & Sleep",
        "Immune Support",   "Energy & Vitality",
        "Detox & Cleanse",  "Skin Health",
    ]

    // MARK: - State

    @State private var selectedAge:  String? = nil
    @State private var selectedGoal: String? = nil
    @State private var isSaving = false
    @State private var saveError: String? = nil

    private var canProceed: Bool { selectedAge != nil && selectedGoal != nil && !isSaving }

    private var greeting: String {
        if let name = displayName, !name.isEmpty {
            return "Welcome, \(name.components(separatedBy: " ").first ?? name)."
        }
        return "Welcome."
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            LinearGradient(colors: [.forest, .moss], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.fern)
                            .padding(.bottom, 4)

                        Text(greeting)
                            .font(.notoSerif(size: 28, weight: .bold))
                            .foregroundColor(.cream)

                        Text("Tell us a little about yourself so we can personalise your herbal journey.")
                            .font(.notoSans(size: 14))
                            .foregroundColor(.mist)
                            .lineSpacing(3)
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 64)
                    .padding(.bottom, 40)

                    // Age bracket
                    sectionLabel("How old are you?")

                    FlowRow(spacing: 10) {
                        ForEach(ageBrackets, id: \.self) { bracket in
                            chip(bracket, selected: selectedAge == bracket) {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedAge = bracket
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 36)

                    // Wellness goal
                    sectionLabel("What's your primary wellness goal?")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(wellnessGoals, id: \.self) { goal in
                            goalCard(goal, selected: selectedGoal == goal) {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedGoal = goal
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 36)

                    // Error
                    if let err = saveError {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(err)
                        }
                        .font(.notoSans(size: 13))
                        .foregroundColor(.gold)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 16)
                    }

                    // CTA
                    Button { submit() } label: {
                        HStack(spacing: 10) {
                            if isSaving {
                                ProgressView().tint(.forest)
                            } else {
                                Text("Get Started")
                                    .font(.notoSerif(size: 16))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                        }
                        .foregroundColor(.forest)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(canProceed ? Color.cream : Color.cream.opacity(0.35))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                    }
                    .disabled(!canProceed)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 56)
                }
            }
        }
    }

    // MARK: - Sub-views

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.notoSerif(size: 17, weight: .bold))
            .foregroundColor(.cream)
            .padding(.horizontal, 28)
            .padding(.bottom, 14)
    }

    @ViewBuilder
    private func chip(_ label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.notoSans(size: 14, weight: selected ? .semibold : .regular))
                .foregroundColor(selected ? .forest : .cream)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(selected ? Color.cream : Color.clear)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(selected ? Color.cream : Color.mist.opacity(0.45), lineWidth: 1.5)
                )
        }
    }

    @ViewBuilder
    private func goalCard(_ label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.notoSans(size: 13, weight: selected ? .semibold : .regular))
                .foregroundColor(selected ? .forest : .cream)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .padding(.horizontal, 8)
                .background(selected ? Color.cream : Color.white.opacity(0.06))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(selected ? Color.cream : Color.mist.opacity(0.3), lineWidth: 1.5)
                )
        }
    }

    // MARK: - Action

    private func submit() {
        guard let age = selectedAge, let goal = selectedGoal else { return }
        isSaving = true
        saveError = nil

        Task { @MainActor in
            do {
                try await FirestoreService.shared.saveUserProfile(
                    uid: userID,
                    ageBracket: age,
                    wellnessGoal: goal
                )
            } catch {
                // Profile save is non-blocking — surface the error but still proceed.
                saveError = "Profile couldn't be saved — you can update it later."
            }
            isSaving = false
            authVM.completeWelcome(userID: userID, displayName: displayName)
        }
    }
}

// MARK: - FlowRow

/// Simple wrapping row — chips flow left-to-right and wrap to the next line.
struct FlowRow: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                y += rowHeight + spacing
                totalHeight = y
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        totalHeight += rowHeight
        return CGSize(width: width, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
