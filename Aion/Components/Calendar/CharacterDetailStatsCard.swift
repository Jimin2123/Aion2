//
//  CharacterDetailStatsCard.swift
//  Aion
//
//  Created by 정지민 on 1/19/26.
//

import SwiftUI

struct CharacterDetailStatsCard: View {
    let characterName: String
    let monthlyIncome: Int

    // 임시 데이터 (나중에 실제 데이터로 교체)
    private let energy: (current: Int, max: Int, charged: Int) = (450, 600, 100)
    private let conquestTicket: (current: Int, max: Int, charged: Int) = (15, 18, 2)
    private let transcendenceTicket: (current: Int, max: Int, charged: Int) = (3, 6, 1)

    // 임시 최근 기록
    private var recentRecords: [(type: String, name: String, reward: Int, color: Color)] {
        [
            ("정복", "어둠의 군주", 5_200_000, .green),
            ("초월", "영원의 탑 1층", 8_500_000, .purple),
            ("건당", "드레니움 강화석", 3_200_000, .orange)
        ]
    }

    var body: some View {
        VStack(spacing: 16) {
            // 상단: 캐릭터 정보 + 이번 달 수익
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundStyle(.blue)

                    Text(characterName)
                        .font(.title3)
                        .fontWeight(.bold)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("이번 달")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(formatNumber(monthlyIncome)) 키나")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                }
            }

            Divider()

            // 중단: 리소스 현황
            VStack(alignment: .leading, spacing: 10) {
                Text("보유 현황")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(spacing: 10) {
                    // 오드 에너지
                    ResourceRow(
                        icon: "bolt.fill",
                        iconColor: .orange,
                        label: "에너지",
                        current: energy.current,
                        max: energy.max,
                        charged: energy.charged
                    )

                    // 정복 티켓
                    ResourceRow(
                        icon: "ticket.fill",
                        iconColor: .green,
                        label: "정복",
                        current: conquestTicket.current,
                        max: conquestTicket.max,
                        charged: conquestTicket.charged
                    )

                    // 초월 티켓
                    ResourceRow(
                        icon: "ticket.fill",
                        iconColor: .purple,
                        label: "초월",
                        current: transcendenceTicket.current,
                        max: transcendenceTicket.max,
                        charged: transcendenceTicket.charged
                    )
                }
            }

            Divider()

            // 하단: 최근 기록
            VStack(alignment: .leading, spacing: 10) {
                Text("최근 기록")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(recentRecords, id: \.name) { record in
                    RecentRecordRow(
                        type: record.type,
                        name: record.name,
                        reward: record.reward,
                        color: record.color
                    )
                }
            }
        }
        .padding()
        .background(.background)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
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

// MARK: - 리소스 Row
struct ResourceRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let current: Int
    let max: Int
    let charged: Int

    private var progress: Double {
        guard max > 0 else { return 0 }
        return Double(current) / Double(max)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 아이콘 + 라벨 + 수치
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(iconColor)

                Text(label)
                    .font(.caption)
                    .foregroundStyle(.primary)

                Spacer()

                HStack(spacing: 2) {
                    Text("\(current)/\(max)")
                        .font(.caption)
                        .foregroundStyle(.primary)

                    if charged > 0 {
                        Text("+\(charged)")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }

            // 프로그레스 바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(iconColor.opacity(0.7))
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - 최근 기록 Row
struct RecentRecordRow: View {
    let type: String
    let name: String
    let reward: Int
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            // 타입 뱃지
            Text(type)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(color)
                .cornerRadius(4)

            // 던전 이름
            Text(name)
                .font(.caption)
                .foregroundStyle(.primary)

            Spacer()

            // 보상
            Text("+\(formatNumber(reward))")
                .font(.caption)
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

        CharacterDetailStatsCard(
            characterName: "캐릭터1",
            monthlyIncome: 70_200_000
        )
        .padding()
    }
}
