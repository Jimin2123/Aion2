//
//  CalendarView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // 캘린더 헤더
                    CalendarHeader(
                        currentDate: $viewModel.currentDate,
                        selectedCharacter: $viewModel.selectedCharacter,
                        characters: viewModel.characters,
                        onPreviousMonth: { viewModel.moveMonth(by: -1) },
                        onNextMonth: { viewModel.moveMonth(by: 1) }
                    )

                    // 요일 헤더
                    CalendarWeekdayHeader()

                    Divider()

                    // 달력 그리드
                    VStack(spacing: 0) {
                        ForEach(viewModel.weeksInMonth.indices, id: \.self) { weekIndex in
                            HStack(spacing: 0) {
                                ForEach(0..<7, id: \.self) { dayIndex in
                                    let date = viewModel.weeksInMonth[weekIndex][dayIndex]
                                    CalendarDayCell(
                                        date: date,
                                        isToday: viewModel.isToday(date),
                                        isSelected: viewModel.isSelected(date),
                                        income: viewModel.getIncome(for: date),
                                        hasRecord: viewModel.hasRecord(for: date),
                                        onTap: { viewModel.selectDate(date) }
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
                                    viewModel.moveMonth(by: -1)
                                } else {
                                    viewModel.moveMonth(by: 1)
                                }
                            }
                    )

                    Divider()
                        .padding(.top, 8)

                    // 선택된 캐릭터에 따라 다른 카드 표시
                    if viewModel.selectedCharacter == "전체" {
                        MonthlyStatsCard(
                            totalIncome: viewModel.monthlyTotal,
                            totalPlaytimeMinutes: viewModel.monthlyPlaytimeMinutes,
                            bestDay: viewModel.bestIncomeDay,
                            bestDayIncome: viewModel.bestDayIncome,
                            averageIncome: viewModel.averageDailyIncome,
                            characterStats: viewModel.characterIncomeStats
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    } else {
                        CharacterDetailStatsCard(
                            characterName: viewModel.selectedCharacter,
                            monthlyIncome: viewModel.getCharacterMonthlyIncome(viewModel.selectedCharacter)
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
            .sheet(isPresented: $viewModel.showRecordSheet) {
                if let date = viewModel.selectedDate {
                    DayDetailSheet(
                        date: date,
                        characters: viewModel.characters,
                        selectedCharacter: viewModel.selectedCharacter
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
                }
            }
            .refreshable {
                viewModel.refresh()
            }
        }
    }
}

#Preview {
    CalendarView()
}
