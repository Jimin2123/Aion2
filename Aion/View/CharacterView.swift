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
        NavigationView {
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
            .sheet(isPresented: $viewModel.showAddCharacterSheet) {
                AddCharacterSheet(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Add Character Sheet

struct AddCharacterSheet: View {
    @Bindable var viewModel: CharacterViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("캐릭터 정보") {
                    TextField("캐릭터 이름", text: $viewModel.newCharacterName)
                }
            }
            .navigationTitle("캐릭터 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        viewModel.newCharacterName = ""
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        viewModel.saveNewCharacter()
                    }
                    .disabled(viewModel.newCharacterName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    CharacterView()
}
