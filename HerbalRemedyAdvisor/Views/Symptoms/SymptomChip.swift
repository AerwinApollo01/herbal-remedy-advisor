import SwiftUI

struct SymptomChip: View {
    let symptom: String
    let isSelected: Bool
    let onTap: () -> Void

    private let icons: [String: String] = [
        "Bloating & Gas":    "wind",
        "Fatigue":           "bolt.slash",
        "Digestive Issues":  "flame",
        "Skin Irritation":   "allergens",
        "Brain Fog":         "cloud",
        "Sugar Cravings":    "star",
        "Joint Discomfort":  "figure.walk",
        "Sleep Issues":      "moon",
        "Appetite Loss":     "fork.knife",
        "Mood Changes":      "waveform"
    ]

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: icons[symptom] ?? "leaf")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .mist : .sage)
                Text(symptom)
                    .font(.notoSans(size: 11, weight: .semibold))
                    .foregroundColor(isSelected ? .mist : .subtext)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(isSelected ? Color.forest : Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.forest : Color.mist, lineWidth: 1.5)
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(symptom)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
