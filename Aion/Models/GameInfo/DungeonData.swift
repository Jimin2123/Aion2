//
//  GameData.swift
//  Aion
//
//  Created by 정지민 on 1/16/26.
//

struct DungeonData {
    
    // MARK: - 정복 던전 공통 규칙 (상수)
    struct CDungeonRule {
        static let ticketCost = 1 // 티켓 소모
        static let energyCost = GameConstants.cDungeonEnergyCost // 오드 에너지 소모
        
        // 고정 보상
        static let fixedSelentium = 7 // 셀렌티움
        static let fixedEnchantStone = 2000 // 강화석
        
        // 오드 획득
        static let oddRollCount = 3 // 오드 획득 기회 3번
    }
    
    // MARK: - 초월 던전 공통 규칙 (상수)
    struct TDungeonRule {
        static let ticketCost: Int = 1 // 티켓 소모
        static let energyCost: Int = GameConstants.tDungeonEnergyCost // 오드에너지 소모
        
        static let baseKinah: Int = 300_000 // 1단계 기본 보상
        static let stepKinah: Int = 30_000 // 단계별 증가량
        
        static let fixedSelentium: Int = 10 // 셀렌티움
        
        static func calcKinah(for stage: Int) -> Int {
            // 1단계는 기본값, 2단계부터 증가분
            let calculated = baseKinah + ((stage - 1) * stepKinah)
            
            if stage == 10 { return 600_000 }
            
            return calculated
        }
        
        static func calcCP(for stage: Int) -> Int {
            switch stage {
                case 1...3: return 1200
                case 4...6: return 1800
                case 7...10: return 2400
                default: return 2400
            }
        }
    }
    
    // MARK: - 초월 던전 리스트
    static let tDungeonsList: [DungeonStage] = [
        DungeonStage(id: 100, type: .transcendence, name: "데우스 연구기지", stage: generateTDungeonStagesDetail(maxStage: 10)),
        DungeonStage(id: 101, type: .transcendence, name: "조각난 아르카니스", stage: generateTDungeonStagesDetail(maxStage: 10))
    ]
    
    private static func generateTDungeonStagesDetail(maxStage: Int = 10) -> [StageDetail] {
        var stages: [StageDetail] = []
        
        for i in 1...maxStage {
            
            let kinah = TDungeonRule.calcKinah(for: i) // 보상 키나 계산
            let cp = TDungeonRule.calcCP(for: i) // 최소 전투력 계산
            
            let stage = StageDetail(minimumCP: cp, difficulty: .level(i), kinah: kinah, rareMaterial: .none, dropRate: 0)
            
            stages.append(stage)
        }
        return stages
    }
    
    // 분노의 사념(thought) (크라오, 드라웁니르용)
    private static let thoughtStages: [StageDetail] = [
        StageDetail(minimumCP: 1000, difficulty: .normal, kinah: 300_000, rareMaterial: .thought, dropRate: 3.0),
        StageDetail(minimumCP: 2400, difficulty: .hard, kinah: 500_000, rareMaterial: .thought, dropRate: 4.0)
    ]
        
    // 분노의 의지(will) (우구구르, 바크론용)
    private static let willStages: [StageDetail] = [
        StageDetail(minimumCP: 1600, difficulty: .normal, kinah: 400_000, rareMaterial: .will, dropRate: 3.6),
        StageDetail(minimumCP: 2500, difficulty: .hard, kinah: 500_000, rareMaterial: .will, dropRate: 4.8)
    ]
    
    // 분노의 자아(ego) (불의 신전, 사나운 뿔 암굴용)
    private static let egoStages: [StageDetail] = [
        StageDetail(minimumCP: 2200, difficulty: .normal, kinah: 500_000, rareMaterial: .ego, dropRate: 4.8),
        StageDetail(minimumCP: 2600, difficulty: .hard, kinah: 500_000, rareMaterial: .ego, dropRate: 6.0)
    ]
    
    static let cDungeonsList: [DungeonStage] = [
            
        // 1. 크라오 & 드라웁니르
        DungeonStage(id: 1, type: .conquest, name: "크라오", stage: thoughtStages),
        DungeonStage(id: 2, type: .conquest, name: "드라웁니르", stage: thoughtStages),
        
        // 2. 우구구르 & 바크론
        DungeonStage(id: 3, type: .conquest, name: "우구구르", stage: willStages),
        DungeonStage(id: 4, type: .conquest, name: "바크론", stage: willStages),
        
        // 3. 불의 신전 & 사나운 뿔 암굴
        DungeonStage(id: 5, type: .conquest, name: "불의 신전", stage: egoStages),
        DungeonStage(id: 6, type: .conquest, name: "사나운 뿔 암굴", stage: egoStages)
    ]
}
