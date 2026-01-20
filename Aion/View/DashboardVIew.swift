//
//  DashBoardView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()

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

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            VStack(spacing: 12) {
                                ForEach(viewModel.characters) { character in
                                    CharacterCard(
                                        name: character.name,
                                        baseEnergy: character.baseEnergy,
                                        maxBaseEnergy: character.maxBaseEnergy,
                                        chargedEnergy: character.chargedEnergy,
                                        cTicket: character.cTicket,
                                        chargedCTicket: character.chargedCTicket,
                                        tTicket: character.tTicket,
                                        chargedTTicket: character.chargedTTicket,
                                        energyRechargeIn: character.energyRechargeIn,
                                        cTicketRechargeIn: character.cTicketRechargeIn,
                                        tTicketRechargeIn: character.tTicketRechargeIn,
                                        totalIncome: character.totalIncome
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("대시보드")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.refresh()
            }
        }
    }
}

#Preview {
    DashboardView()
}
