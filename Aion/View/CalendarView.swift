//
//  CalendarView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var selectedCharacter = "전체"
    @State private var showRecordSheet = false

    // 임시 캐릭터 목록 (나중에 실제 데이터로 교체)
    private let characters = ["캐릭터1", "캐릭터2", "캐릭터3"]

    // 임시 데이터 (나중에 실제 데이터로 교체)
    private let sampleIncomeData: [Date: Int] = {
        var data: [Date: Int] = [:]
        let calendar = Calendar.current
        let today = Date()

        for i in 0..<15 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let startOfDay = calendar.startOfDay(for: date)
                data[startOfDay] = Int.random(in: 5_000_000...20_000_000)
            }
        }
        return data
    }()

    private var calendar: Calendar {
        Calendar.current
    }

    private var monthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }

    private var daysInMonth: [Date?] {
        var days: [Date?] = []

        // 첫째 날의 요일 (0 = 일요일)
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1

        // 앞쪽 빈 칸
        for _ in 0..<firstWeekday {
            days.append(nil)
        }

        // 해당 월의 날짜들
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }

        return days
    }

    private var weeksInMonth: [[Date?]] {
        var weeks: [[Date?]] = []
        var currentWeek: [Date?] = []

        for day in daysInMonth {
            currentWeek.append(day)
            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }

        // 마지막 주 채우기
        if !currentWeek.isEmpty {
            while currentWeek.count < 7 {
                currentWeek.append(nil)
            }
            weeks.append(currentWeek)
        }

        return weeks
    }

    private var monthlyTotal: Int {
        sampleIncomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.values.reduce(0, +)
    }

    private var monthlyPlaytimeMinutes: Int {
        // 임시: 하루 평균 45분 플레이
        sampleIncomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.count * 45
    }

    private var bestIncomeDay: Date? {
        sampleIncomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.max(by: { $0.value < $1.value })?.key
    }

    private var bestDayIncome: Int {
        sampleIncomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.values.max() ?? 0
    }

    private var averageDailyIncome: Int {
        let monthData = sampleIncomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }
        guard !monthData.isEmpty else { return 0 }
        return monthData.values.reduce(0, +) / monthData.count
    }

    // 임시 캐릭터별 수익 데이터
    private var characterIncomeStats: [(name: String, income: Int)] {
        [
            ("캐릭터1", Int(Double(monthlyTotal) * 0.45)),
            ("캐릭터2", Int(Double(monthlyTotal) * 0.35)),
            ("캐릭터3", Int(Double(monthlyTotal) * 0.20))
        ]
    }

    private func getCharacterMonthlyIncome(_ characterName: String) -> Int {
        characterIncomeStats.first { $0.name == characterName }?.income ?? 0
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 캘린더 헤더
                    CalendarHeader(
                        currentDate: $currentDate,
                        selectedCharacter: $selectedCharacter,
                        characters: characters,
                        onPreviousMonth: { moveMonth(by: -1) },
                        onNextMonth: { moveMonth(by: 1) }
                    )

                    // 요일 헤더
                    CalendarWeekdayHeader()

                    Divider()

                    // 달력 그리드
                    VStack(spacing: 0) {
                        ForEach(weeksInMonth.indices, id: \.self) { weekIndex in
                            HStack(spacing: 0) {
                                ForEach(0..<7, id: \.self) { dayIndex in
                                    let date = weeksInMonth[weekIndex][dayIndex]
                                    CalendarDayCell(
                                        date: date,
                                        isToday: isToday(date),
                                        isSelected: isSelected(date),
                                        income: getIncome(for: date),
                                        hasRecord: hasRecord(for: date),
                                        onTap: { selectDate(date) }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onEnded { value in
                                let horizontal = value.translation.width
                                if horizontal > 0 {
                                    // 오른쪽 스와이프 -> 이전 달
                                    moveMonth(by: -1)
                                } else {
                                    // 왼쪽 스와이프 -> 다음 달
                                    moveMonth(by: 1)
                                }
                            }
                    )

                    Divider()
                        .padding(.top, 8)

                    // 선택된 캐릭터에 따라 다른 카드 표시
                    if selectedCharacter == "전체" {
                        // 전체 통계 카드
                        MonthlyStatsCard(
                            totalIncome: monthlyTotal,
                            totalPlaytimeMinutes: monthlyPlaytimeMinutes,
                            bestDay: bestIncomeDay,
                            bestDayIncome: bestDayIncome,
                            averageIncome: averageDailyIncome,
                            characterStats: characterIncomeStats
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    } else {
                        // 캐릭터별 상세 카드
                        CharacterDetailStatsCard(
                            characterName: selectedCharacter,
                            monthlyIncome: getCharacterMonthlyIncome(selectedCharacter)
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("캘린더")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showRecordSheet) {
                if let date = selectedDate {
                    DayDetailSheet(
                        date: date,
                        characters: characters,
                        selectedCharacter: selectedCharacter
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func moveMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentDate = newDate
            }
        }
    }

    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDateInToday(date)
    }

    private func isSelected(_ date: Date?) -> Bool {
        guard let date = date, let selected = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selected)
    }

    private func getIncome(for date: Date?) -> Int? {
        guard let date = date else { return nil }
        let startOfDay = calendar.startOfDay(for: date)
        return sampleIncomeData[startOfDay]
    }

    private func hasRecord(for date: Date?) -> Bool {
        getIncome(for: date) != nil
    }

    private func selectDate(_ date: Date?) {
        guard let date = date else { return }
        selectedDate = date
        showRecordSheet = true
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    CalendarView()
}
