import SwiftUI

struct QuoteCard: View {
    let quote: Quote
    let dayNumber: Int
    let tradition: Tradition?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                if let t = tradition {
                    Text(t.flag).font(.system(size: 13))
                    Text("DAY \(dayNumber) WISDOM · \(t.name.uppercased())")
                        .font(.notoSans(size: 9, weight: .semibold))
                        .foregroundColor(.sage)
                        .kerning(0.4)
                }
            }

            Text("\u{201C}")
                .font(.notoSerif(size: 30))
                .foregroundColor(.mist)
                .padding(.bottom, -16)

            Text(quote.q)
                .notoSerifItalic(size: 13)
                .foregroundColor(.forest)
                .lineSpacing(5)

            Text("— \(quote.a)")
                .font(.notoSans(size: 10, weight: .semibold))
                .foregroundColor(.gold)

            Text(quote.c)
                .font(.notoSans(size: 10))
                .foregroundColor(.subtext)
                .lineSpacing(3)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.forest.opacity(0.06), Color.sage.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.mist, lineWidth: 1))
        .cornerRadius(16)
    }
}
