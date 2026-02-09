//
//  DashboardViewModel.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

@Observable
class DashboardViewModel {
    var characters: [CharacterStatus] = []
    var isLoading: Bool = false
    var errorMessage: String?

    init() {
        loadCharacters()
    }

    // MARK: - Computed Properties

    var totalIncome: Int {
        characters.reduce(0) { $0 + $1.totalIncome }
    }

    var totalBaseEnergy: Int {
        characters.reduce(0) { $0 + $1.baseEnergy }
    }

    var totalChargedEnergy: Int {
        characters.reduce(0) { $0 + $1.chargedEnergy }
    }

    // MARK: - Actions

    func loadCharacters() {
        isLoading = true
        errorMessage = nil

        // TODO: 실제 데이터 로드 로직으로 교체
        // 임시 데이터
        characters = [
            CharacterStatus(
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
            ),
            CharacterStatus(
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
        ]

        isLoading = false
    }

    func refresh() {
        loadCharacters()
    }
}
