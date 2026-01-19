//
//  RecordCreateViewModel.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

@Observable
class RecordCreateViewModel {
    let date: Date
    let characterName: String

    // 기본 선택
    var selectedType: RecordType = .conquest
    var selectedDungeon: DungeonStage?
    var selectedDifficulty: Difficulty = .normal

    // 옵션
    var isDoubleReward: Bool = false
    var hasMaterialDrop: Bool = false
    var materialDropCount: Int = 1
    var isBusRide: Bool = false
    var busFee: String = ""
    var durationMinutes: String = ""

    // 거래소 옵션
    var exchangeType: ExchangeType = .world
    var exchangePrice: String = ""
    var exchangeItemName: String = ""

    // 메모
    var memo: String = ""

    init(date: Date, characterName: String) {
        self.date = date
        self.characterName = characterName
    }

    // MARK: - Computed Properties

    var dungeonList: [DungeonStage] {
        switch selectedType {
        case .conquest:
            return DungeonData.cDungeonsList
        case .transcendence:
            return DungeonData.tDungeonsList
        case .exchange:
            return []
        }
    }

    var difficultyOptions: [StageDetail] {
        selectedDungeon?.stage ?? []
    }

    var selectedStageDetail: StageDetail? {
        selectedDungeon?.stage.first { $0.difficulty == selectedDifficulty }
    }

    var calculatedReward: Int {
        guard let detail = selectedStageDetail else { return 0 }
        let baseReward = detail.kinah
        return isDoubleReward ? baseReward * 2 : baseReward
    }

    var calculatedSelentium: Int {
        guard selectedDungeon != nil else { return 0 }
        let baseSelentium = selectedType == .conquest
            ? DungeonData.CDungeonRule.fixedSelentium
            : DungeonData.TDungeonRule.fixedSelentium
        return isDoubleReward ? baseSelentium * 2 : baseSelentium
    }

    var selentiumValue: Int {
        calculatedSelentium * GameConstants.selentiumPrice
    }

    var busFeeValue: Int {
        Int(busFee.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    var exchangePriceValue: Int {
        Int(exchangePrice.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    var exchangeRegFee: Int {
        guard selectedType == .exchange, exchangePriceValue > 0 else { return 0 }
        return exchangePriceValue * GameConstants.exchange_reg_fee / 100
    }

    var exchangeTax: Int {
        guard selectedType == .exchange, exchangePriceValue > 0 else { return 0 }
        return exchangePriceValue * exchangeType.taxRate / 100
    }

    var exchangeNetIncome: Int {
        guard selectedType == .exchange, exchangePriceValue > 0 else { return 0 }
        return exchangePriceValue - exchangeRegFee - exchangeTax
    }

    var netProfit: Int {
        if selectedType == .exchange {
            return exchangeNetIncome
        } else {
            return calculatedReward + selentiumValue - busFeeValue
        }
    }

    var materialInfo: RareMaterial {
        selectedStageDetail?.rareMaterial ?? .none
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    var isValid: Bool {
        if selectedType == .exchange {
            return exchangePriceValue > 0
        } else {
            return selectedDungeon != nil
        }
    }

    // MARK: - Actions

    func onTypeChanged() {
        selectedDungeon = nil
        selectedDifficulty = selectedType == .conquest ? .normal : .level(1)
        hasMaterialDrop = false
        materialDropCount = 1
        exchangePrice = ""
        exchangeItemName = ""
    }

    func onDungeonChanged() {
        if let first = selectedDungeon?.stage.first {
            selectedDifficulty = first.difficulty
        }
    }

    func saveRecord() {
        // TODO: 실제 저장 로직 구현
    }

    // MARK: - Formatters

    func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    func formatWithComma(_ text: String) -> String {
        let digits = text.filter { $0.isNumber }
        guard let number = Int(digits), number > 0 else {
            return digits.isEmpty ? "" : "0"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? digits
    }
}
