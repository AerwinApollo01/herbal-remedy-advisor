import SwiftUI

struct JournalScreen: View {
    @EnvironmentObject var journalVM: JournalViewModel
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var isCompletingDay = false
    @State private var reminderTime: Date = JournalScreen.defaultReminderDate(hour: 7, minute: 30)

    private var recipe: Remedy? { journalVM.journalRecipe }
    private var tradition: Tradition? {
        TraditionDatabase.tradition(for: recipe?.tid ?? "")
    }
    private var todayQuote: Quote {
        journalVM.getQuote(for: journalVM.currentDayNumber)
    }

    var body: some View {
        ZStack {
            if let recipe {
                mainJournal(recipe: recipe)
                    .transition(reduceMotion ? .identity : .opacity)
            } else {
                emptyState
                    .transition(reduceMotion ? .identity : .opacity)
            }

            if journalVM.showDayOverlay {
                DayCompleteOverlay()
                    .transition(reduceMotion ? .identity : .opacity)
            }

            if journalVM.showProtocolOverlay {
                ProtocolCompleteOverlay()
                    .transition(reduceMotion ? .identity : .opacity)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: journalVM.showDayOverlay)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: journalVM.showProtocolOverlay)
        .onAppear { syncReminderTime() }
        .onChange(of: journalVM.reminderHour)   { _ in syncReminderTime() }
        .onChange(of: journalVM.reminderMinute) { _ in syncReminderTime() }
        .alert("Notifications Blocked", isPresented: $journalVM.showNotificationDeniedAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("To receive daily reminders, enable notifications for Nise in Settings.")
        }
    }

    private func mainJournal(recipe: Remedy) -> some View {
        VStack(spacing: 0) {
            AppHeader(
                icon: "book.closed.fill",
                label: "Protocol Journal",
                title: "Remedy Calendar",
                subtitle: "Track your daily practice"
            )

            ScrollView {
                VStack(spacing: 16) {
                    heroSection(recipe: recipe)
                    summaryStatsBar
                    ProgressBar(
                        label: recipe.name,
                        percent: journalVM.progressPercent,
                        duration: recipe.duration
                    )
                    JournalCalendar()

                    // Day detail card (revealed on tap)
                    if let selected = journalVM.selectedCalDay {
                        DayDetailCard(selected: selected)
                            .animation(reduceMotion ? nil : .easeInOut(duration: 0.25),
                                       value: journalVM.selectedCalDay?.dayOfMonth)
                    }

                    TodayTaskCard()

                    // Mark Day Complete button
                    if !journalVM.isProtocolComplete {
                        Button {
                            guard !isCompletingDay else { return }
                            isCompletingDay = true
                            journalVM.completeDay()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isCompletingDay = false
                            }
                        } label: {
                            Label("Mark Day Complete", systemImage: "checkmark.circle")
                                .font(.notoSerif(size: 15))
                                .foregroundColor(.cream)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.forest)
                                .cornerRadius(16)
                                .shadow(color: .forest.opacity(0.3), radius: 6, y: 3)
                        }
                        .accessibilityLabel("Mark today complete")
                        .accessibilityHint("Marks today's protocol as completed")
                    }

                    reminderRow

                    QuoteCard(quote: todayQuote, dayNumber: journalVM.currentDayNumber, tradition: tradition)

                    AchievementRow()

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .background(Color.cream)
        }
        .background(Color.cream)
    }

    private func heroSection(recipe: Remedy) -> some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.notoSerif(size: 16, weight: .bold))
                    .foregroundColor(.forest)
                Text(recipe.tradition)
                    .font(.notoSans(size: 11))
                    .foregroundColor(.sage)
                let times = journalVM.timesCompleted(remedy: recipe)
                if times > 0 {
                    Label("\(times) \(times == 1 ? "completion" : "completions")", systemImage: "trophy.fill")
                        .font(.notoSans(size: 10, weight: .semibold))
                        .foregroundColor(.gold)
                }
            }
            Spacer()
            Label("\(journalVM.completedDays.count)", systemImage: "flame.fill")
                .font(.notoSans(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.gold)
                .cornerRadius(20)
                .accessibilityLabel("\(journalVM.completedDays.count) days completed")
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 12, y: 3)
    }

    private var summaryStatsBar: some View {
        HStack(spacing: 0) {
            statCell(value: "\(journalVM.completedDays.count)", label: "DAYS DONE")
            Divider().background(Color.mist.opacity(0.4)).frame(height: 36)
            statCell(value: "\(journalVM.daysLeft)", label: "DAYS LEFT")
            Divider().background(Color.mist.opacity(0.4)).frame(height: 36)
            statCell(value: "\(Int(journalVM.progressPercent * 100))%", label: "COMPLETE")
        }
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 12, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(journalVM.completedDays.count) days done, \(journalVM.daysLeft) days left, \(Int(journalVM.progressPercent * 100)) percent complete")
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.notoSerif(size: 20, weight: .bold))
                .foregroundColor(.forest)
            Text(label)
                .font(.notoSans(size: 9, weight: .semibold))
                .foregroundColor(.subtext)
                .kerning(0.3)
        }
        .frame(maxWidth: .infinity)
    }

    private var reminderRow: some View {
        VStack(spacing: 0) {
            HStack {
                Label("Daily Reminder", systemImage: "alarm")
                    .font(.notoSans(size: 12))
                    .foregroundColor(.subtext)
                Spacer()
                Toggle("", isOn: Binding(
                    get: { journalVM.reminderOn },
                    set: { enabled in
                        Task { await journalVM.setReminder(enabled: enabled) }
                    }
                ))
                .labelsHidden()
                .tint(.forest)
                .accessibilityLabel("Daily reminder")
            }

            if journalVM.reminderOn {
                Divider()
                    .background(Color.mist.opacity(0.2))
                    .padding(.vertical, 10)

                HStack {
                    Text("Remind me at")
                        .font(.notoSans(size: 12))
                        .foregroundColor(.subtext)
                    Spacer()
                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .tint(.forest)
                        .onChange(of: reminderTime) { newTime in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: newTime)
                            journalVM.updateReminderTime(
                                hour: comps.hour ?? 7,
                                minute: comps.minute ?? 30
                            )
                        }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: journalVM.reminderOn)
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            AppHeader(
                icon: "book.closed.fill",
                label: "Protocol Journal",
                title: "Remedy Calendar",
                subtitle: "Track your daily practice"
            )
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.sage)
                Text("No Active Protocol")
                    .font(.notoSerif(size: 20))
                    .foregroundColor(.forest)
                Text("Browse remedies and tap \"Start\" to begin tracking your active protocol.")
                    .font(.notoSans(size: 13))
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.cream)
        }
        .background(Color.cream)
    }

    // MARK: - Helpers

    private func syncReminderTime() {
        reminderTime = JournalScreen.defaultReminderDate(
            hour: journalVM.reminderHour,
            minute: journalVM.reminderMinute
        )
    }

    private static func defaultReminderDate(hour: Int, minute: Int) -> Date {
        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute
        return Calendar.current.date(from: comps) ?? Date()
    }
}
