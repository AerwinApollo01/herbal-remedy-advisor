import SwiftUI

struct TraditionBadge: View {
    let tradition: String
    let tid: String
    let color: String

    var body: some View {
        Text(tradition)
            .font(.notoSans(size: 9, weight: .semibold))
            .foregroundColor(Color(hex: color))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color(hex: color).opacity(0.15))
            .cornerRadius(20)
    }
}
