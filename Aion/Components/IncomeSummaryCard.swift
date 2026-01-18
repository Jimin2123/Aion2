//
//  DashBoardView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//
import SwiftUI
import Charts

struct DailyIncome: Identifiable {
    let id = UUID()
    let day: String
    let income: Int
    let isToday: Bool
}

struct IncomeSummaryCard: View {
    private let weeklyData: [DailyIncome] = [
        DailyIncome(day: "월", income: 8_500_000, isToday: false),
        DailyIncome(day: "화", income: 11_200_000, isToday: false),
        DailyIncome(day: "수", income: 6_800_000, isToday: false),
        DailyIncome(day: "목", income: 15_300_000, isToday: false),
        DailyIncome(day: "금", income: 9_450_000, isToday: false),
        DailyIncome(day: "토", income: 18_200_000, isToday: false),
        DailyIncome(day: "일", income: 12_450_000, isToday: true)
    ]

    private var totalIncome: Int { weeklyData.reduce(0) { $0 + $1.income } }
    private var todayIncome: Int { weeklyData.first { $0.isToday }?.income ?? 0 }
    private var avgIncome: Int { totalIncome / 7 }

    var body: some View {
        VStack(spacing: 16) {
            // 헤더
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("주간 수익")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(formatKinah(totalIncome)) 키나")
                        .font(.headline)
                }
                Spacer()
            }

            // 차트
            Chart(weeklyData) { item in
                BarMark(
                    x: .value("요일", item.day),
                    y: .value("수익", item.income)
                )
                .foregroundStyle(
                    item.isToday
                        ? LinearGradient(colors: [.blue, .purple], startPoint: .bottom, endPoint: .top)
                        : LinearGradient(colors: [.blue.opacity(0.4), .blue.opacity(0.6)], startPoint: .bottom, endPoint: .top)
                )
                .cornerRadius(5)
                .annotation(position: .top) {
                    if item.isToday {
                        Text("\(item.income / 1_000_000)M")
                            .font(.caption2.bold())
                            .foregroundStyle(.blue)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundStyle(.gray.opacity(0.3))
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue / 1_000_000)M")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let day = value.as(String.self) {
                            let isToday = weeklyData.first { $0.day == day }?.isToday ?? false
                            Text(day)
                                .font(.caption)
                                .fontWeight(isToday ? .bold : .regular)
                                .foregroundStyle(isToday ? .blue : .secondary)
                        }
                    }
                }
            }
            .frame(height: 150)

            Divider()
            
            // 하단 요약
            HStack {
                Label("\(formatKinah(avgIncome))/일", systemImage: "chart.line.uptrend.xyaxis")
                Spacer()
                let goalPercent = 80
                Label("목표 \(goalPercent)%", systemImage: "flag")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.06), Color.purple.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }

    private func formatKinah(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    IncomeSummaryCard()
}
