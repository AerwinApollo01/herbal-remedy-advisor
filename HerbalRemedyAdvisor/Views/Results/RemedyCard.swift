import SwiftUI

struct RemedyCard: View {
    let remedy: Remedy
    let onViewProtocol: () -> Void
    let onStart: () -> Void

    /// When non-nil the card renders the editorial lock badge over the header.
    var isLocked: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [Color(hex: remedy.color), Color(hex: remedy.color).opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .saturation(isLocked ? 0.2 : 1.0)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: isLocked ? "lock.fill" : remedy.sfSymbol)
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(isLocked ? 0.5 : 0.9))

                        Spacer()

                        // System priority badge — populated from Firestore metadata
                        if let priority = remedy.systemPriority {
                            systemPriorityBadge(priority)
                        }

                        // Lock indicator
                        if isLocked {
                            lockBadge
                        }
                    }

                    Text(remedy.name)
                        .font(.notoSerif(size: 15, weight: .bold))
                        .foregroundColor(.white.opacity(isLocked ? 0.55 : 1.0))
                        .lineLimit(2)
                    Text(remedy.origin)
                        .font(.notoSans(size: 10))
                        .foregroundColor(.white.opacity(isLocked ? 0.35 : 0.8))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
            }
            .frame(minHeight: 88)

            // MARK: Body
            VStack(alignment: .leading, spacing: 10) {
                // Ingredient chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(remedy.ingredients, id: \.self) { ing in
                            Text(ing)
                                .font(.notoSans(size: 10))
                                .foregroundColor(isLocked ? .subtext.opacity(0.4) : .forest)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.mist.opacity(isLocked ? 0.4 : 1.0))
                                .cornerRadius(10)
                        }
                    }
                }

                Text(remedy.desc)
                    .font(.notoSans(size: 11))
                    .foregroundColor(.subtext.opacity(isLocked ? 0.4 : 1.0))
                    .lineLimit(3)

                // Action row
                HStack(spacing: 8) {
                    Button(action: onViewProtocol) {
                        HStack(spacing: 6) {
                            if isLocked {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 9))
                            }
                            Text(isLocked ? "Preview →" : "View Protocol →")
                                .font(.notoSans(size: 9, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 9)
                        .frame(maxWidth: .infinity)
                        .background(isLocked ? Color.subtext.opacity(0.5) : Color.forest)
                        .cornerRadius(10)
                    }
                    .accessibilityHint(isLocked ? "Preview locked protocol" : "Opens the full remedy protocol")

                    Button(action: isLocked ? {} : onStart) {
                        Text(isLocked ? "Locked" : "Start Journal")
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(isLocked ? .subtext.opacity(0.5) : .white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 9)
                            .frame(maxWidth: .infinity)
                            .background(isLocked ? Color.mist.opacity(0.5) : Color.gold)
                            .cornerRadius(10)
                    }
                    .disabled(isLocked)
                    .accessibilityHint(isLocked ? "Protocol is locked" : "Begins the protocol journal for this remedy")
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(isLocked ? 0.04 : 0.07), radius: 16, x: 0, y: 4)
        .animation(.easeInOut(duration: 0.2), value: isLocked)
    }

    // MARK: - Sub-views

    @ViewBuilder
    private func systemPriorityBadge(_ priority: String) -> some View {
        Text(priority.uppercased())
            .font(.notoSans(size: 7, weight: .semibold))
            .foregroundColor(.white.opacity(0.85))
            .kerning(0.8)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(Color.white.opacity(0.15))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
    }

    private var lockBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "lock.fill")
                .font(.system(size: 8))
            Text("LOCKED")
                .font(.notoSans(size: 7, weight: .semibold))
                .kerning(0.5)
        }
        .foregroundColor(.white.opacity(0.6))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.3))
        .cornerRadius(8)
    }
}
