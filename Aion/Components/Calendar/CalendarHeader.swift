//
//  CalendarHeader.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CalendarHeader: View {
    @Binding var currentDate: Date
    @Binding var selectedCharacter: String
    let characters: [String]
    var onPreviousMonth: () -> Void
    var onNextMonth: () -> Void

    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: currentDate)
    }

    var body: some View {
        VStack(spacing: 12) {
            // 월 네비게이션
            HStack {
                Button(action: onPreviousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }

                Spacer()

                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: onNextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }

            // 캐릭터 선택
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CharacterChip(
                        name: "전체",
                        isSelected: selectedCharacter == "전체",
                        onTap: { selectedCharacter = "전체" }
                    )

                    ForEach(characters, id: \.self) { character in
                        CharacterChip(
                            name: character,
                            isSelected: selectedCharacter == character,
                            onTap: { selectedCharacter = character }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

struct CharacterChip: View {
    let name: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(name)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.15))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CalendarHeader(
        currentDate: .constant(Date()),
        selectedCharacter: .constant("전체"),
        characters: ["캐릭터1", "캐릭터2", "캐릭터3"],
        onPreviousMonth: {},
        onNextMonth: {}
    )
}
