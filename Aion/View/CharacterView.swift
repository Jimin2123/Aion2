//
//  CharacterView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//
import SwiftUI

struct CharacterView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    AccountInfoCard()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("캐릭터 목록").font(.headline).padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            CharacterCard(
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

                            CharacterCard(
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
                        AddCharacterButton {
                            print("캐릭터 추가")
                        }
                    }
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("캐릭터 관리")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    CharacterView()
}
