import SwiftUI

struct JournalCalendar: View {
    @EnvironmentObject var journalVM: JournalViewModel

    private let cal = Calendar.current
    private let dayLabels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    var body: some View {
        VStack(spacing: 0) {
            monthNavHeader
                .padding(.bottom, 12)

            // Day of week header
            HStack(spacing: 0) {
                ForEach(dayLabels, id: \.self) { d in
                    Text(d)
                        .font(.notoSans(size: 10, weight: .semibold))
                        .foregroundColor(.subtext)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)

            calendarGrid

            legend
                .padding(.top, 10)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 14, x: 0, y: 4)
    }

    // MARK: - Month Nav

    private var monthNavHeader: some View {
        HStack {
            Button { journalVM.prevMonth() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.forest)
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Text(monthYearLabel)
                .font(.notoSerif(size: 15))
                .foregroundColor(.forest)
            Spacer()
            Button { journalVM.nextMonth() } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.forest)
                    .frame(width: 36, height: 36)
            }
        }
    }

    private var monthYearLabel: String {
        var comps = DateComponents()
        comps.year = journalVM.calYear
        comps.month = journalVM.calMonth + 1
        comps.day = 1
        let date = cal.date(from: comps) ?? Date()
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM yyyy"
        return fmt.string(from: date)
    }

    // MARK: - Grid

    private var calendarGrid: some View {
        let days = daysInGrid()
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 7), spacing: 3) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                if let day {
                    calCell(day: day)
                } else {
                    Color.clear.frame(width: 36, height: 36)
                }
            }
        }
    }

    private func calCell(day: Int) -> some View {
        let state = cellState(for: day)
        let protDay = protocolDayNum(for: day)
        let tradColor = traditionColor()
        let isSelected = journalVM.selectedCalDay?.dayOfMonth == day

        return Button {
            if let pd = protDay {
                journalVM.selectCalendarDay(dayOfMonth: day, protDayNum: pd)
            }
        } label: {
            ZStack {
                cellBackground(state: state, tradColor: tradColor)
                VStack(spacing: 2) {
                    Text("\(day)")
                        .font(.notoSans(size: state == .empty ? 10 : 10, weight: .semibold))
                        .foregroundColor(dayNumberColor(state: state))
                    if let pd = protDay, state != .done && state != .todayActive {
                        Text("\(pd)")
                            .font(.system(size: 7))
                            .foregroundColor(tradColor.opacity(0.8))
                    }
                    if state == .done {
                        Text("✓")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(width: 36, height: 36)
            .overlay(
                isSelected && protDay != nil
                    ? RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.gold, lineWidth: 2)
                    : nil
            )
            .animation(.easeInOut(duration: 0.15), value: state)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel(day: day, state: state, protDay: protDay))
        .frame(minWidth: 44, minHeight: 44)
    }

    @ViewBuilder
    private func cellBackground(state: CalCellState, tradColor: Color) -> some View {
        switch state {
        case .done:
            Circle().fill(tradColor.opacity(0.85))
        case .todayActive:
            Circle().fill(Color.gold.opacity(0.9))
                .overlay(Circle().stroke(Color.gold, lineWidth: 2).scaleEffect(1.2))
        case .upcoming:
            Circle().fill(tradColor.opacity(0.12))
        case .nonProtocol, .empty:
            Color.clear
        }
    }

    private func dayNumberColor(state: CalCellState) -> Color {
        switch state {
        case .done, .todayActive: return .white
        case .upcoming: return .subtext
        case .nonProtocol: return .subtext
        case .empty: return .clear
        }
    }

    private func accessibilityLabel(day: Int, state: CalCellState, protDay: Int?) -> String {
        guard let recipe = journalVM.journalRecipe, let pd = protDay else {
            return "Day \(day)"
        }
        let status: String
        switch state {
        case .done: status = "completed"
        case .todayActive: status = "today"
        case .upcoming: status = "upcoming"
        default: status = "not in protocol"
        }
        return "Day \(day), \(recipe.name), Protocol day \(pd), \(status)"
    }

    // MARK: - Legend

    private var legend: some View {
        HStack(spacing: 16) {
            if let recipe = journalVM.journalRecipe {
                HStack(spacing: 5) {
                    Image(systemName: recipe.sfSymbol).font(.system(size: 10)).foregroundColor(.subtext)
                    Text(recipe.name)
                        .font(.notoSans(size: 9))
                        .foregroundColor(.subtext)
                        .lineLimit(1)
                }
            }
            legendDot(color: .gold, label: "Today")
            legendDot(color: traditionColor().opacity(0.4), label: "Upcoming")
        }
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label).font(.notoSans(size: 9)).foregroundColor(.subtext)
        }
    }

    // MARK: - Helpers

    private func daysInGrid() -> [Int?] {
        var comps = DateComponents()
        comps.year = journalVM.calYear
        comps.month = journalVM.calMonth + 1
        comps.day = 1
        guard let firstDay = cal.date(from: comps) else { return [] }
        let weekday = cal.component(.weekday, from: firstDay) - 1 // 0=Sun
        let range = cal.range(of: .day, in: .month, for: firstDay)!
        var days: [Int?] = Array(repeating: nil, count: weekday)
        days += (1...range.count).map { Optional($0) }
        // Pad to fill last row
        while days.count % 7 != 0 { days.append(nil) }
        return days
    }

    private func protocolDayNum(for day: Int) -> Int? {
        var comps = DateComponents()
        comps.year = journalVM.calYear
        comps.month = journalVM.calMonth + 1
        comps.day = day
        guard let date = cal.date(from: comps) else { return nil }
        return journalVM.protocolDayNumber(for: date)
    }

    private func isToday(_ day: Int) -> Bool {
        var comps = DateComponents()
        comps.year = journalVM.calYear
        comps.month = journalVM.calMonth + 1
        comps.day = day
        guard let date = cal.date(from: comps) else { return false }
        return cal.isDateInToday(date)
    }

    private func cellState(for day: Int) -> CalCellState {
        guard let pd = protocolDayNum(for: day) else { return .nonProtocol }
        if journalVM.completedDays.contains(pd) { return .done }
        if pd == journalVM.currentDayNumber { return .todayActive }
        return .upcoming
    }

    private func traditionColor() -> Color {
        Color(hex: journalVM.journalRecipe?.color ?? "#1A2E1A")
    }
}

enum CalCellState {
    case done, todayActive, upcoming, nonProtocol, empty
}
