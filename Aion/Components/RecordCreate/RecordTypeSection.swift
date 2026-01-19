//
//  RecordTypeSection.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct RecordTypeSection: View {
    @Binding var selectedType: RecordType

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("기록 유형")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                ForEach(RecordType.allCases, id: \.self) { type in
                    RecordTypeButton(
                        type: type,
                        isSelected: selectedType == type,
                        onTap: { selectedType = type }
                    )
                }
            }
        }
    }
}

// MARK: - 기록 타입 버튼
struct RecordTypeButton: View {
    let type: RecordType
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : type.color)

                Text(type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? type.color : type.color.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
