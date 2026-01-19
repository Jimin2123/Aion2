//
//  GameConstants.swift
//  Aion
//
//  Created by 정지민 on 1/16/26.
//
import Foundation

struct GameConstants {
    
    static let dailyResetHour: Int = 5 // 기준 시간 (05시)
    
    // MARK: - Price 고정 목록
    static let selentiumPrice: Int = 5000 // 셀렌티움 가격 (5000키나)
    static let membershipPrice: Int = 45_000 // 맴버쉽 구독 가격 (45000원)
    static let membershipEnergyPrice: Int = 100_000 // 멤버쉽 에너지 (10만 키나)
    
    
    // MARK: - 오드에너지 제작, 구매 (횟수, 충전량)
    static let maxMembershipBuyEnergy: Int = 7 // 에너지 최대 구매 횟수
    static let membershipEnergyRechargeAmount: Int = 40 // 멤버쉽 구매 시 충전량
    static let maxMorphExchangeEnergy: Int = 7 // 에너지 최대 제작 횟수
    static let morphEnergyRechargeAmount: Int = 40 // 제작 시 충전량
    
    
    // MARK: - 던전 에너지 사용량
    static let eDungeonEnergyCost: Int = 30 // 탐험 던전 에너지 사용량
    static let cDungeonEnergyCost: Int = 40 // 정복 던전 에너지 사용량
    static let tDungeonEnergyCost: Int = 40 // 초월 던전 에너지 사용량
    
    // MARK: - 오드 에너지 : 05시 기준 (3시간 간격)
    static let energyRechargeHour: Int = 3
    static let energyRechargeInterval: TimeInterval = Double(energyRechargeHour) * 60 * 60
    
    // MARK: - 정복 던전 티켓 : 최대 보유량 21+@ | 05시 기준 (8시간 간격)
    static let maxCTicket = 21
    static let cDungeonIntervalHour: Int = 8
    static let cDungeonTicketInterval: TimeInterval = Double(cDungeonIntervalHour) * 60 * 60
    
    // MARK: - 초월 던전 티켓 : 최대 보유량 14+@ | 05기준 (12시간 간격)
    static let maxTTicket = 14
    static let tDungeonIntervalHour: Int = 12
    static let tDungeonTicketInterval: TimeInterval = Double(tDungeonIntervalHour) * 60 * 60
}
