//
//  MonthlyStatsCard.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct MonthlyStatsCard: View {
    let totalIncome: Int
    let dungeonCount: Int
    let bestDay: Date?
    let bestDayIncome: Int
    let averageIncome: Int
    let characterStats: [(name: String, income: Int)]

    var body: some View {
        VStack(spacing: 16) {
            // 상단: 총 수익
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("이번 달 총 수익")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(formatNumber(totalIncome)) 키나")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
                Spacer()

                // 던전 횟수
                VStack(alignment: .trailing, spacing: 4) {
                    Text("던전")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(dungeonCount)회")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }

            Divider()

            // 중단: 통계 그리드
            HStack(spacing: 0) {
                // 최고 수익일
                StatItemCentered(
                    icon: "crown.fill",
                    iconColor: .yellow,
                    title: "최고 수익일",
                    value: bestDayString,
                    subValue: "+\(formatCompact(bestDayIncome))"
                )

                Divider()
                    .frame(height: 50)

                // 일 평균
                StatItemCentered(
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: .blue,
                    title: "일 평균",
                    value: "\(formatCompact(averageIncome))",
                    subValue: "키나"
                )
            }

            Divider()

            // 하단: 캐릭터별 수익
            VStack(spacing: 10) {
                HStack {
                    Text("캐릭터별 수익")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                ForEach(characterStats, id: \.name) { stat in
                    CharacterIncomeRow(
                        name: stat.name,
                        income: stat.income
                    )
                }
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    private var bestDayString: String {
        guard let date = bestDay else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatCompact(_ value: Int) -> String {
        if value >= 100_000_000 {
            return String(format: "%.1f억", Double(value) / 100_000_000)
        } else if value >= 10_000_000 {
            return String(format: "%.0fM", Double(value) / 1_000_000)
        } else if value >= 1_000_000 {
            return String(format: "%.1fM", Double(value) / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.0fK", Double(value) / 1_000)
        }
        return "\(value)"
    }
}

// MARK: - 통계 아이템 (중앙 정렬)
struct StatItemCentered: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subValue: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 캐릭터 수익 Row
struct CharacterIncomeRow: View {
    let name: String
    let income: Int

    var body: some View {
        HStack {
            // 캐릭터 아이콘
            Image(systemName: "person.circle.fill")
                .font(.title3)
                .foregroundStyle(.blue)

            // 캐릭터 이름
            Text(name)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()

            // 수익금
            Text("\(formatNumber(income)) 키나")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.orange)
        }
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()

        MonthlyStatsCard(
            totalIncome: 156_000_000,
            dungeonCount: 45,
            bestDay: Date(),
            bestDayIncome: 18_500_000,
            averageIncome: 10_400_000,
            characterStats: [
                ("캐릭터1", 70_200_000),
                ("캐릭터2", 54_600_000),
                ("캐릭터3", 31_200_000)
            ]
        )
        .padding()
    }
}
