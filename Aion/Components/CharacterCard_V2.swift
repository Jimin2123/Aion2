//
//  CharacterStatusCard.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CharacterCard_V2: View {
    let name: String
    let baseEnergy: Int
    let maxBaseEnergy: Int
    let chargedEnergy: Int
    let cTicket: Int
    let chargedCTicket: Int
    let tTicket: Int
    let chargedTTicket: Int
    let energyRechargeIn: Int?    // 분 단위
    let cTicketRechargeIn: Int?   // 분 단위
    let tTicketRechargeIn: Int?   // 분 단위
    let totalIncome: Int

    private var energyProgress: Double {
        Double(baseEnergy) / Double(maxBaseEnergy)
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 캐릭터 이름
            HStack {
                Text(name).font(.system(size: 18, weight: .semibold))
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
            }

            // 에너지 바
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "bolt.fill").font(.system(size: 12)).foregroundStyle(.yellow)
                    Text("오드 에너지").font(Font.caption).foregroundStyle(Color.secondary)
                    Text("\(baseEnergy)/\(maxBaseEnergy)").font(.caption).foregroundStyle(.secondary)
                    if chargedEnergy > 0 {
                        Text("+\(chargedEnergy)").font(.caption).foregroundStyle(.blue)
                    }
                    Spacer()
                    if let minutes = energyRechargeIn {
                        Text(formatTime(minutes)).font(.caption).foregroundStyle(.orange)
                    }
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.2))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geometry.size.width * energyProgress)
                    }
                }
                .frame(height: 8)
            }

            // 티켓 및 수익 정보
            HStack(spacing: 0) {
                // 정복 티켓
                VStack(spacing: 6) {
                    Text("정복")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Image(systemName: "ticket.fill")
                            .font(.title3)
                            .foregroundStyle(.green)
                        Text("\(cTicket)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        if chargedCTicket > 0 {
                            Text("+\(chargedCTicket)")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                    if let minutes = cTicketRechargeIn {
                        Text(formatTime(minutes))
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                }
                .frame(maxWidth: .infinity)

                Divider().frame(height: 60).padding(.horizontal, 12)

                // 초월 티켓
                VStack(spacing: 6) {
                    Text("초월")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 4) {
                        Image(systemName: "ticket.fill")
                            .font(.title3)
                            .foregroundStyle(.purple)
                        Text("\(tTicket)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        if chargedTTicket > 0 {
                            Text("+\(chargedTTicket)")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                    if let minutes = tTicketRechargeIn {
                        Text(formatTime(minutes))
                            .font(.caption2)
                            .foregroundStyle(.purple)
                    }
                }
                .frame(maxWidth: .infinity)

                Divider().frame(height: 40).padding(.horizontal, 12)

                // 수익
                VStack(spacing: 4) {
                    Image(systemName: "wonsign.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.orange)
                    Text(formatNumber(totalIncome))
                        .font(.callout)
                        .fontWeight(.bold)
                    Text("주간수익")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
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
    VStack {
        CharacterCard_V2(
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

        CharacterCard_V2(
            name: "캐릭터 2",
            baseEnergy: 680,
            maxBaseEnergy: 840,
            chargedEnergy: 0,
            cTicket: 21,
            chargedCTicket: 0,
            tTicket: 14,
            chargedTTicket: 0,
            energyRechargeIn: nil,
            cTicketRechargeIn: nil,
            tTicketRechargeIn: nil,
            totalIncome: 800_000
        )
    }
}
