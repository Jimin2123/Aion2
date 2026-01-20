//
//  CharacterViewModel.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct AccountInfo {
    var isSubscribed: Bool
    var subscriptionExpiryDate: Date?
    var totalCDungeonCount: Int
    var totalTDungeonCount: Int
    var subscriptionDaysRemaining: Int?

    var cDungeonEfficiency: Double {
        switch totalCDungeonCount {
        case 0..<84: return 1.0
        case 84..<105: return 0.8
        case 105..<126: return 0.6
        case 126..<147: return 0.4
        default: return 0.2
        }
    }

    var tDungeonEfficiency: Double {
        switch totalTDungeonCount {
        case 0..<56: return 1.0
        case 56..<70: return 0.8
        case 70..<84: return 0.6
        case 84..<98: return 0.4
        default: return 0.2
        }
    }
}

@Observable
class CharacterViewModel {
    var account: AccountInfo?
    var characters: [CharacterStatus] = []
    var isLoading = false
    var errorMessage: String?

    var showAddCharacterSheet = false
    var newCharacterName = ""

    init() {
        loadData()
    }

    // MARK: - Computed Properties

    var characterCount: Int {
        characters.count
    }

    var totalIncome: Int {
        characters.reduce(0) { $0 + $1.totalIncome }
    }

    // MARK: - Actions

    func loadData() {
        isLoading = true
        errorMessage = nil

        // TODO: 실제 데이터 로드 로직으로 교체
        // 임시 계정 정보
        account = AccountInfo(
            isSubscribed: true,
            subscriptionExpiryDate: Calendar.current.date(byAdding: .day, value: 15, to: Date()),
            totalCDungeonCount: 45,
            totalTDungeonCount: 28,
            subscriptionDaysRemaining: 15
        )

        // 임시 캐릭터 데이터
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
        loadData()
    }

    func addCharacter() {
        showAddCharacterSheet = true
    }

    func saveNewCharacter() {
        guard !newCharacterName.isEmpty else { return }

        // TODO: 실제 저장 로직 구현
        let newCharacter = CharacterStatus(
            name: newCharacterName,
            baseEnergy: 0,
            maxBaseEnergy: account?.isSubscribed == true ? 840 : 560,
            chargedEnergy: 0,
            cTicket: 21,
            chargedCTicket: 0,
            tTicket: 14,
            chargedTTicket: 0,
            energyRechargeIn: nil,
            cTicketRechargeIn: nil,
            tTicketRechargeIn: nil,
            totalIncome: 0
        )

        characters.append(newCharacter)
        newCharacterName = ""
        showAddCharacterSheet = false
    }

    func deleteCharacter(at indexSet: IndexSet) {
        // TODO: 실제 삭제 로직 구현
        characters.remove(atOffsets: indexSet)
    }

    func deleteCharacter(_ character: CharacterStatus) {
        // TODO: 실제 삭제 로직 구현
        characters.removeAll { $0.id == character.id }
    }
}
