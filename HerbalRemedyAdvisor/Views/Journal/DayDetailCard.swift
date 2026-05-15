import SwiftUI

struct DayDetailCard: View {
    @EnvironmentObject var journalVM: JournalViewModel
    let selected: SelectedCalDay

    private var recipe: Remedy? { journalVM.journalRecipe }

    private var status: DayStatus {
        if journalVM.completedDays.contains(selected.protDayNum) { return .done }
        let cal = Calendar.current
        var comps = DateComponents()
        comps.year = journalVM.calYear
        comps.month = journalVM.calMonth + 1
        comps.day = selected.dayOfMonth
        if let date = cal.date(from: comps), cal.isDateInToday(date) { return .today }
        return .upcoming
    }

    private var quote: Quote? {
        guard status == .done || status == .today else { return nil }
        return journalVM.getQuote(for: selected.protDayNum)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider().background(Color.mist)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 10) {
                    Text(recipe?.icon ?? "🌿")
                        .font(.system(size: 26))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("PROTOCOL DAY \(selected.protDayNum) · \(dateLabel)")
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(.subtext)
                            .kerning(0.3)
                        Text(recipe?.name ?? "")
                            .font(.notoSerif(size: 14))
                            .foregroundColor(.forest)
                        if let t = TraditionDatabase.tradition(for: recipe?.tid ?? "") {
                            TraditionBadge(tradition: t.name, tid: t.id, color: t.color)
                        }
                    }
                    Spacer()
                    statusBadge
                }

                if let q = quote {
                    Divider().background(Color.mist)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("DAY WISDOM")
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(.sage)
                            .kerning(0.4)
                        Text(q.q)
                            .notoSerifItalic(size: 11)
                            .foregroundColor(.forest)
                            .lineSpacing(4)
                        Text("— \(q.a)")
                            .font(.notoSans(size: 9, weight: .semibold))
                            .foregroundColor(.gold)
                    }
                }
            }
            .padding(14)
            .background(Color.white)
            .cornerRadius(16)
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private var dateLabel: String {
        var comps = DateComponents()
        comps.year = journalVM.calYear
        comps.month = journalVM.calMonth + 1
        comps.day = selected.dayOfMonth
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM d"
        return fmt.string(from: Calendar.current.date(from: comps) ?? Date())
    }

    @ViewBuilder
    private var statusBadge: some View {
        switch status {
        case .done:
            Text("✅ Done")
                .font(.notoSans(size: 9, weight: .semibold))
                .foregroundColor(.forest)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.fern.opacity(0.2))
                .cornerRadius(8)
        case .today:
            Text("⭐ Today")
                .font(.notoSans(size: 9, weight: .semibold))
                .foregroundColor(.copper)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.gold.opacity(0.2))
                .cornerRadius(8)
        case .upcoming:
            Text("🔒 Upcoming")
                .font(.notoSans(size: 9, weight: .semibold))
                .foregroundColor(.subtext)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
        }
    }
}

enum DayStatus { case done, today, upcoming }
