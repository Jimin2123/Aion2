//
//  CalendarViewModel.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

@Observable
class CalendarViewModel {
    // MARK: - State
    var currentDate = Date()
    var selectedDate: Date?
    var selectedCharacter = "전체"
    var showRecordSheet = false

    // MARK: - Data
    var characters: [String] = []
    var incomeData: [Date: Int] = [:]
    var isLoading = false
    var errorMessage: String?

    private var calendar: Calendar {
        Calendar.current
    }

    init() {
        loadData()
    }

    // MARK: - Calendar Computed Properties

    var monthStart: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }

    var daysInMonth: [Date?] {
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

    var weeksInMonth: [[Date?]] {
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

    // MARK: - Statistics Computed Properties

    var monthlyTotal: Int {
        incomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.values.reduce(0, +)
    }

    var monthlyPlaytimeMinutes: Int {
        // TODO: 실제 플레이타임 데이터로 교체
        incomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.count * 45
    }

    var bestIncomeDay: Date? {
        incomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.max(by: { $0.value < $1.value })?.key
    }

    var bestDayIncome: Int {
        incomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }.values.max() ?? 0
    }

    var averageDailyIncome: Int {
        let monthData = incomeData.filter { date, _ in
            calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
        }
        guard !monthData.isEmpty else { return 0 }
        return monthData.values.reduce(0, +) / monthData.count
    }

    var characterIncomeStats: [(name: String, income: Int)] {
        // TODO: 실제 캐릭터별 수익 데이터로 교체
        guard !characters.isEmpty else { return [] }

        let ratios = [0.45, 0.35, 0.20]
        return characters.enumerated().map { index, name in
            let ratio = index < ratios.count ? ratios[index] : 0.1
            return (name, Int(Double(monthlyTotal) * ratio))
        }
    }

    // MARK: - Helper Methods

    func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDateInToday(date)
    }

    func isSelected(_ date: Date?) -> Bool {
        guard let date = date, let selected = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selected)
    }

    func getIncome(for date: Date?) -> Int? {
        guard let date = date else { return nil }
        let startOfDay = calendar.startOfDay(for: date)
        return incomeData[startOfDay]
    }

    func hasRecord(for date: Date?) -> Bool {
        getIncome(for: date) != nil
    }

    func getCharacterMonthlyIncome(_ characterName: String) -> Int {
        characterIncomeStats.first { $0.name == characterName }?.income ?? 0
    }

    // MARK: - Actions

    func moveMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentDate = newDate
            }
        }
    }

    func selectDate(_ date: Date?) {
        guard let date = date else { return }
        selectedDate = date
        showRecordSheet = true
    }

    func loadData() {
        isLoading = true
        errorMessage = nil

        // TODO: 실제 데이터 로드 로직으로 교체
        // 임시 캐릭터 목록
        characters = ["캐릭터1", "캐릭터2", "캐릭터3"]

        // 임시 수익 데이터 생성
        var data: [Date: Int] = [:]
        let today = Date()

        for i in 0..<15 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let startOfDay = calendar.startOfDay(for: date)
                data[startOfDay] = Int.random(in: 5_000_000...20_000_000)
            }
        }
        incomeData = data

        isLoading = false
    }

    func refresh() {
        loadData()
    }

    // MARK: - Formatters

    func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
