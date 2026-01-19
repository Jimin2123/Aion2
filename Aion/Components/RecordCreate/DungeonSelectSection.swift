//
//  DungeonSelectSection.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct DungeonSelectSection: View {
    let dungeonList: [DungeonStage]
    @Binding var selectedDungeon: DungeonStage?
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("던전 선택")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(dungeonList) { dungeon in
                        DungeonSelectChip(
                            name: dungeon.name,
                            isSelected: selectedDungeon?.id == dungeon.id,
                            color: accentColor,
                            onTap: { selectedDungeon = dungeon }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - 던전 선택 칩
struct DungeonSelectChip: View {
    let name: String
    let isSelected: Bool
    let color: Color
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(name)
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
