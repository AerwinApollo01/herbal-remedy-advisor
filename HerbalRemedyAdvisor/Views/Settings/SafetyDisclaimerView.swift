import SwiftUI

struct SafetyDisclaimerView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.forest.ignoresSafeArea()

            VStack(spacing: 0) {

                // Handle + title
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.mist.opacity(0.3))
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                Text("Safety Disclaimer")
                    .font(.notoSerif(size: 20, weight: .bold))
                    .foregroundColor(.cream)
                    .padding(.bottom, 24)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        disclaimerBlock(
                            icon: "info.circle.fill",
                            heading: "For Educational Purposes Only",
                            body: "The information provided in Nise is for educational and informational purposes only. It is not intended as medical advice, diagnosis, or treatment. Nothing in this app should be used as a substitute for professional medical guidance."
                        )

                        disclaimerBlock(
                            icon: "cross.circle.fill",
                            heading: "Not FDA Evaluated",
                            body: "The herbal remedies and wellness protocols presented in this app have not been evaluated by the Food and Drug Administration (FDA). They are not intended to diagnose, treat, cure, or prevent any disease or health condition."
                        )

                        disclaimerBlock(
                            icon: "person.fill.checkmark",
                            heading: "Consult Your Doctor",
                            body: "Always consult a qualified healthcare professional before beginning any new health regimen — particularly if you are pregnant, nursing, have an existing medical condition, or are taking prescription medications. Some herbs may interact with medications or may not be appropriate for everyone."
                        )

                        disclaimerBlock(
                            icon: "heart.fill",
                            heading: "A Wellness Companion",
                            body: "Nise is a wellness companion, not a medical tool. It is designed to support mindful daily habits inspired by traditional healing systems — not to replace clinical care."
                        )

                        disclaimerBlock(
                            icon: "exclamationmark.triangle.fill",
                            heading: "In an Emergency",
                            body: "If you are experiencing a medical emergency, stop using this app and contact emergency services immediately by calling 911 or your local emergency number."
                        )

                        Text("Last updated: May 2026")
                            .font(.notoSans(size: 11))
                            .foregroundColor(.mist.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                            .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.notoSans(size: 15, weight: .semibold))
                        .foregroundColor(.forest)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.cream)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
    }

    @ViewBuilder
    private func disclaimerBlock(icon: String, heading: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.fern)
                Text(heading)
                    .font(.notoSerif(size: 15, weight: .bold))
                    .foregroundColor(.cream)
            }
            Text(body)
                .font(.notoSans(size: 13))
                .foregroundColor(.mist)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
