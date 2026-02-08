//
//  CharacterDetailView.swift
//  Aion
//
//  Created by 정지민 on 2/8/26.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: CharacterStatus
    @State private var showCalendar = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 리소스 현황
                resourceSection

                // 주간 수익
                incomeSection

                // 최근 기록
                recentRecordsSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showCalendar) {
            CalendarView(initialCharacter: character.name)
        }
    }

    // MARK: - Resource Section

    private var resourceSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("보유 현황")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            // 오드 에너지
            ResourceStatusRow(
                icon: "bolt.fill",
                iconColor: .orange,
                label: "오드 에너지",
                current: character.baseEnergy,
                max: character.maxBaseEnergy,
                charged: character.chargedEnergy,
                rechargeIn: character.energyRechargeIn
            )

            Divider()

            // 정복 던전 티켓
            ResourceStatusRow(
                icon: "ticket.fill",
                iconColor: .green,
                label: "정복 던전",
                current: character.cTicket,
                max: 21,
                charged: character.chargedCTicket,
                rechargeIn: character.cTicketRechargeIn
            )

            Divider()

            // 초월 던전 티켓
            ResourceStatusRow(
                icon: "ticket.fill",
                iconColor: .purple,
                label: "초월 던전",
                current: character.tTicket,
                max: 14,
                charged: character.chargedTTicket,
                rechargeIn: character.tTicketRechargeIn
            )
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Income Section

    private var incomeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("주간 수익")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            HStack {
                Image(systemName: "wonsign.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)

                Text(formatNumber(character.totalIncome))
                    .font(.title2)
                    .fontWeight(.bold)

                Text("키나")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Recent Records Section

    private var recentRecordsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("최근 기록")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)

                Spacer()

                Button("전체보기") {
                    showCalendar = true
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            // TODO: 실제 기록 데이터 연결
            VStack(spacing: 0) {
                Text("아직 기록이 없습니다")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Helpers

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)시간 \(mins)분"
        }
        return "\(mins)분"
    }
}

// MARK: - Resource Status Row

private struct ResourceStatusRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let current: Int
    let max: Int
    let charged: Int
    let rechargeIn: Int?

    private var progress: Double {
        guard max > 0 else { return 0 }
        return min(Double(current) / Double(max), 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 라벨 + 수치
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(iconColor)

                    Text(label)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("\(current)")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("/ \(max)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if charged > 0 {
                        Text("+\(charged)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.blue)
                    }
                }
            }

            // 프로그레스 바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray.opacity(0.15))

                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                colors: [iconColor.opacity(0.8), iconColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 10)

            // 재충전 시간
            if let minutes = rechargeIn {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("충전까지 \(formatTime(minutes))")
                        .font(.caption)
                }
                .foregroundStyle(iconColor)
            }
        }
    }

    private func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)시간 \(mins)분"
        }
        return "\(mins)분"
    }
}

#Preview {
    NavigationView {
        CharacterDetailView(
            character: CharacterStatus(
                name: "캐릭터 1",
                baseEnergy: 450,
                maxBaseEnergy: 560,
                chargedEnergy: 120,
                cTicket: 15,
                chargedCTicket: 3,
                tTicket: 8,
                chargedTTicket: 2,
                energyRechargeIn: 45,
                cTicketRechargeIn: 180,
                tTicketRechargeIn: 420,
                totalIncome: 450_000
            )
        )
    }
}
