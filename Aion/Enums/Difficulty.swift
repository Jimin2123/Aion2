//
//  Difficulty.swift
//  Aion
//
//  Created by 정지민 on 1/16/26.
//

enum Difficulty: Codable, Comparable {
    case none
    case normal
    case hard
    case level(Int)
    
    var sortOrder: Int {
        switch self {
            case .none: return -1
            case .normal: return 0
            case .hard: return 1
            case .level(let n): return 100 + n // 단계는 뒤쪽에 배치
        }
    }
}
