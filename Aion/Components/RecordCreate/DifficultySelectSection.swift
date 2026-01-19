//
//  DifficultySelectSection.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct DifficultySelectSection: View {
    let difficultyOptions: [StageDetail]
    @Binding var selectedDifficulty: Difficulty
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("난이도")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(difficultyOptions, id: \.id) { detail in
                        DifficultySelectChip(
                            difficulty: detail.difficulty,
                            isSelected: selectedDifficulty == detail.difficulty,
                            color: accentColor,
                            onTap: { selectedDifficulty = detail.difficulty }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - 난이도 선택 칩
struct DifficultySelectChip: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let color: Color
    var onTap: () -> Void

    private var displayName: String {
        switch difficulty {
        case .none:
            return "없음"
        case .normal:
            return "보통"
        case .hard:
            return "어려움"
        case .level(let n):
            return "\(n)단계"
        }
    }

    var body: some View {
        Button(action: onTap) {
            Text(displayName)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? color : Color.gray.opacity(0.1))
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}
