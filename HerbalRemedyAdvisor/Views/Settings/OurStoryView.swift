import SwiftUI

struct OurStoryView: View {
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

                Text("Our Story")
                    .font(.notoSerif(size: 20, weight: .bold))
                    .foregroundColor(.cream)
                    .padding(.bottom, 24)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        paragraph(
                            "In 2019, my father was diagnosed with severe rheumatoid arthritis in both knees. I will never forget the day I watched him lie on the couch completely incapacitated, unable to stand or cross the room because of the sheer, agonizing pain. Traditional US treatments like viscosupplementation provided brief windows of relief, but they were temporary bandages on a system experiencing a massive, ongoing inflammatory response. He wanted his life back. He wanted to walk, travel, and move freely."
                        )

                        paragraph(
                            "Refusing to watch him suffer, I turned to the internet, digging into every corner of global health to find answers. I immersed myself in the anti-inflammatory diets of different cultures around the world. As I researched and mapped out these regional traditions, my father became a master of the natural botanical ingredients themselves."
                        )

                        paragraph(
                            "That difficult lifestyle change changed everything. Today, he still manages his pain and faces occasional flare-ups, but the shift allowed him to reclaim his life. He is walking, traveling, and doing what he loves."
                        )

                        paragraph(
                            "I built Nise because I realized that every healing tradition has something the others do not. Across global cultures — from Ayurveda to European Herbalism — communities have spent centuries cultivating a quiet, profound archive of natural remedies to restore systemic balance. This ancestral knowledge shouldn't be trapped in old text histories or hidden across scattered web forums; it deserves a living, accessible place in our modern routines."
                        )

                        paragraph(
                            "Nise was born to bridge this gap for other families. We make this heritage accessible without the noise — free of extreme claims, quick-fix myths, and ingredient overwhelm. Just thoughtful, culturally attributed guidance and daily journal tracking to support your body's natural resilience, one day at a time."
                        )

                        paragraph(
                            "My mission is to help you protect this ancient lineage, remember your roots, and build a daily practice that is small, intentional, and entirely yours."
                        )

                        Spacer(minLength: 32)
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
    private func paragraph(_ text: String) -> some View {
        Text(text)
            .font(.notoSans(size: 14))
            .foregroundColor(.mist)
            .lineSpacing(6)
            .fixedSize(horizontal: false, vertical: true)
    }
}
