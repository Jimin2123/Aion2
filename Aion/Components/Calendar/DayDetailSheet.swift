//
//  DayDetailSheet.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

// 던전 기록 모델 (임시)
struct DungeonRecord: Identifiable {
    let id = UUID()
    let type: RecordType
    let dungeonName: String
    let characterName: String
    let reward: Int
    let time: Date

    enum RecordType {
        case conquest       // 정복
        case transcendence  // 초월
        case crafting       // 건당

        var title: String {
            switch self {
            case .conquest: return "정복"
            case .transcendence: return "초월"
            case .crafting: return "건당"
            }
        }

        var color: Color {
            switch self {
            case .conquest: return .green
            case .transcendence: return .purple
            case .crafting: return .orange
            }
        }

        var icon: String {
            switch self {
            case .conquest: return "shield.fill"
            case .transcendence: return "star.fill"
            case .crafting: return "hammer.fill"
            }
        }
    }
}

struct DayDetailSheet: View {
    @Environment(\.dismiss) private var dismiss

    let date: Date
    let characters: [String]
    let selectedCharacter: String  // "전체" 또는 특정 캐릭터

    @State private var expandedCharacters: Set<String> = []
    @State private var showCharacterSelect = false
    @State private var selectedCharacterForRecord: String = ""
    @State private var showRecordCreate = false

    // 임시 전체 데이터
    private var allRecords: [DungeonRecord] {
        [
            DungeonRecord(type: .conquest, dungeonName: "어둠의 군주", characterName: "캐릭터1", reward: 5_200_000, time: date),
            DungeonRecord(type: .transcendence, dungeonName: "영원의 탑 1층", characterName: "캐릭터1", reward: 8_500_000, time: date),
            DungeonRecord(type: .conquest, dungeonName: "화염의 신전", characterName: "캐릭터2", reward: 4_800_000, time: date),
            DungeonRecord(type: .crafting, dungeonName: "드레니움 강화석", characterName: "캐릭터1", reward: 3_200_000, time: date),
            DungeonRecord(type: .transcendence, dungeonName: "영원의 탑 2층", characterName: "캐릭터2", reward: 9_100_000, time: date),
        ]
    }

    // 필터링된 기록 (캐릭터 선택에 따라)
    private var records: [DungeonRecord] {
        if selectedCharacter == "전체" {
            return allRecords
        } else {
            return allRecords.filter { $0.characterName == selectedCharacter }
        }
    }

    // 캐릭터별 그룹화
    private var groupedRecords: [String: [DungeonRecord]] {
        Dictionary(grouping: records, by: { $0.characterName })
    }

    private var sortedCharacters: [String] {
        groupedRecords.keys.sorted()
    }

    private var totalReward: Int {
        records.reduce(0) { $0 + $1.reward }
    }

    private func characterReward(_ character: String) -> Int {
        groupedRecords[character]?.reduce(0) { $0 + $1.reward } ?? 0
    }

    private var isCharacterSelected: Bool {
        selectedCharacter != "전체"
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 날짜 및 총 수익
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Text(dateString)
                            .font(.title3)
                            .fontWeight(.semibold)

                        if isCharacterSelected {
                            Text("·")
                                .foregroundStyle(.secondary)
                            Text(selectedCharacter)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                        }
                    }

                    HStack(spacing: 4) {
                        Text(isCharacterSelected ? "수익" : "총 수익")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(formatNumber(totalReward)) 키나")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)
                    }
                }
                .padding()

                Divider()

                // 기록 목록
                if records.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundStyle(.tertiary)
                        Text("기록이 없습니다")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else if isCharacterSelected {
                    // 캐릭터 선택됨: 그룹화 없이 리스트로 표시
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(records) { record in
                                RecordRow(record: record, showCharacter: false)
                            }
                        }
                        .padding()
                    }
                } else {
                    // 전체: 캐릭터별 그룹화
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedCharacters, id: \.self) { character in
                                CharacterRecordGroup(
                                    characterName: character,
                                    records: groupedRecords[character] ?? [],
                                    totalReward: characterReward(character),
                                    isExpanded: expandedCharacters.contains(character),
                                    onToggle: { toggleCharacter(character) }
                                )
                            }
                        }
                        .padding()
                    }
                }

                Divider()

                // 기록 추가 버튼
                Button(action: {
                    if isCharacterSelected {
                        // 캐릭터가 선택되어 있으면 바로 등록 화면으로
                        selectedCharacterForRecord = selectedCharacter
                        showRecordCreate = true
                    } else {
                        // 전체면 캐릭터 선택 모달
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            showCharacterSelect = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("기록 추가")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showCharacterSelect) {
                CharacterSelectModalWrapper(
                    isPresented: $showCharacterSelect,
                    characters: characters,
                    onSelect: { character in
                        selectedCharacterForRecord = character
                        showRecordCreate = true
                    }
                )
            }
            .fullScreenCover(isPresented: $showRecordCreate) {
                RecordCreateView(date: date, characterName: selectedCharacterForRecord)
            }
        }
    }

    private func toggleCharacter(_ character: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if expandedCharacters.contains(character) {
                expandedCharacters.remove(character)
            } else {
                expandedCharacters.insert(character)
            }
        }
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// MARK: - 캐릭터별 기록 그룹
struct CharacterRecordGroup: View {
    let characterName: String
    let records: [DungeonRecord]
    let totalReward: Int
    let isExpanded: Bool
    var onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 헤더 (클릭 가능)
            Button(action: onToggle) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(characterName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)

                        Text("\(records.count)건")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("+\(formatNumber(totalReward))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)

            // 펼쳐진 기록 목록
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(records) { record in
                        RecordRow(record: record, showCharacter: false)
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 20)
            }
        }
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// MARK: - 기록 Row 컴포넌트
struct RecordRow: View {
    let record: DungeonRecord
    var showCharacter: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            // 타입 아이콘
            Image(systemName: record.type.icon)
                .font(.title3)
                .foregroundStyle(record.type.color)
                .frame(width: 36, height: 36)
                .background(record.type.color.opacity(0.15))
                .cornerRadius(8)

            // 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(record.dungeonName)
                    .font(.subheadline)
                    .fontWeight(.medium)

                HStack(spacing: 6) {
                    Text(record.type.title)
                        .font(.caption)
                        .foregroundStyle(record.type.color)

                    if showCharacter {
                        Text("·")
                            .foregroundStyle(.tertiary)
                        Text(record.characterName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            // 보상
            Text("+\(formatNumber(record.reward))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.orange)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .cornerRadius(10)
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview("전체") {
    DayDetailSheet(date: Date(), characters: ["캐릭터1", "캐릭터2", "캐릭터3"], selectedCharacter: "전체")
}

#Preview("캐릭터 선택") {
    DayDetailSheet(date: Date(), characters: ["캐릭터1", "캐릭터2", "캐릭터3"], selectedCharacter: "캐릭터1")
}
