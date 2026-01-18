//
//  DashBoardView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    IncomeSummaryCard()
                    
                    // 캐릭터별 에너지/티켓 현황
                    VStack(alignment: .leading, spacing: 12) {
                        Text("캐릭터 현황")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
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
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("대시보드")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardView()
}
