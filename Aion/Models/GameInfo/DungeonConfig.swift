//
//  ConquestConfig.swift
//  Aion
//
//  Created by 정지민 on 1/16/26.
//

import Foundation

// 1. 희귀 재료
enum RareMaterial: String {
    case none = "없음"
    case thought = "분노의 사념"
    case will = "분노의 의지"
    case ego = "분노의 자아"
}

// 2. 난이도별 세부 정보 (보통/어려움 각각의 스펙)
struct StageDetail {
    let id = UUID() // SwiftUI 리스트용 ID
    let minimumCP: Int // 최소 전투력
    let difficulty: Difficulty // 난이도
    let kinah: Int // 보상 키나
    let rareMaterial: RareMaterial // 드랍 재료
    let dropRate: Double // 드랍 확률 (예: 3.0 = 3%)
}

// MARK: - 던전 구조체
struct DungeonStage: Identifiable, Equatable {
    let id: Int // ID
    let type: DungeonType // 던전 타입
    let name: String // 던전 이름 (예: 크라오)
    let stage: [StageDetail] // 던전 정보
    let estimatedSeconds: Int = 900// 소요 시간

    static func == (lhs: DungeonStage, rhs: DungeonStage) -> Bool {
        lhs.id == rhs.id
    }
}
