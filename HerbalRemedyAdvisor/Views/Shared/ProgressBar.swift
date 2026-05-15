import SwiftUI

struct ProgressBar: View {
    let label: String
    let percent: Double
    let duration: Int
    @State private var animatedPct: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.notoSerif(size: 13))
                    .foregroundColor(.forest)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                Text("\(Int(percent * 100))%")
                    .font(.notoSans(size: 12, weight: .semibold))
                    .foregroundColor(.gold)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.mist)
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [.fern, .gold],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * animatedPct, height: 8)
                        .animation(.easeOut(duration: 1.1), value: animatedPct)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Day 1")
                    .font(.notoSans(size: 9))
                    .foregroundColor(.subtext)
                Spacer()
                Text("Day \(duration)")
                    .font(.notoSans(size: 9))
                    .foregroundColor(.subtext)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 4)
        .onAppear { animatedPct = percent }
        .onChange(of: percent) { animatedPct = $0 }
    }
}
