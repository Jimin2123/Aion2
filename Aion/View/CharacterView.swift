//
//  CharacterView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CharacterView: View {
    @State private var viewModel = CharacterViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    AccountInfoCard()

                    VStack(alignment: .leading, spacing: 12) {
                        Text("캐릭터 목록")
                            .font(.headline)
                            .padding(.horizontal)

                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            VStack(spacing: 12) {
                                ForEach(viewModel.characters) { character in
                                    NavigationLink(value: character) {
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
                                    .buttonStyle(.plain)
                                }
                            }

                            AddCharacterButton {
                                viewModel.addCharacter()
                            }
                        }
                    }
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("캐릭터 관리")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                viewModel.refresh()
            }
            .navigationDestination(for: CharacterStatus.self) { character in
                CharacterDetailView(character: character)
            }
            .sheet(isPresented: $viewModel.showAddCharacterSheet) {
                AddCharacterSheet(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    CharacterView()
}
