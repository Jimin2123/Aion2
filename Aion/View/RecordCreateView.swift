//
//  RecordCreateView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

enum RecordType: String, CaseIterable {
    case conquest = "정복"
    case transcendence = "초월"

    var color: Color {
        switch self {
        case .conquest: return .green
        case .transcendence: return .purple
        }
    }

    var icon: String {
        switch self {
        case .conquest: return "shield.fill"
        case .transcendence: return "star.fill"
        }
    }
}

struct RecordCreateView: View {
    @Environment(\.dismiss) private var dismiss

    let date: Date
    let characterName: String

    // 기본 선택
    @State private var selectedType: RecordType = .conquest
    @State private var selectedDungeon: DungeonStage?
    @State private var selectedDifficulty: Difficulty = .normal

    // 옵션
    @State private var isDoubleReward: Bool = false  // 두배 보상 (구독권)
    @State private var hasMaterialDrop: Bool = false // 제작재료 드랍 여부
    @State private var materialDropCount: Int = 1   // 제작재료 개수
    @State private var isBusRide: Bool = false       // 버스 탑승 여부
    @State private var busFee: String = ""           // 버스 요금
    @State private var durationMinutes: String = ""  // 소요시간 (분)

    // 메모
    @State private var memo: String = ""

    // 던전 리스트
    private var dungeonList: [DungeonStage] {
        switch selectedType {
        case .conquest:
            return DungeonData.cDungeonsList
        case .transcendence:
            return DungeonData.tDungeonsList
        }
    }

    // 선택된 던전의 난이도 옵션
    private var difficultyOptions: [StageDetail] {
        selectedDungeon?.stage ?? []
    }

    // 선택된 난이도의 상세 정보
    private var selectedStageDetail: StageDetail? {
        selectedDungeon?.stage.first { $0.difficulty == selectedDifficulty }
    }

    // 계산된 보상
    private var calculatedReward: Int {
        guard let detail = selectedStageDetail else { return 0 }
        let baseReward = detail.kinah
        return isDoubleReward ? baseReward * 2 : baseReward
    }

    // 셀렌티움 보상
    private var calculatedSelentium: Int {
        guard selectedDungeon != nil else { return 0 }
        let baseSelentium = selectedType == .conquest
            ? DungeonData.CDungeonRule.fixedSelentium
            : DungeonData.TDungeonRule.fixedSelentium
        return isDoubleReward ? baseSelentium * 2 : baseSelentium
    }

    // 셀렌티움 키나 환산
    private var selentiumValue: Int {
        calculatedSelentium * GameConstants.selentiumPrice
    }

    // 버스 요금 (Int 변환)
    private var busFeeValue: Int {
        Int(busFee.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    // 순수익 (키나 + 셀렌티움 - 버스비)
    private var netProfit: Int {
        calculatedReward + selentiumValue - busFeeValue
    }

    // 제작재료 정보
    private var materialInfo: RareMaterial {
        selectedStageDetail?.rareMaterial ?? .none
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    private var isValid: Bool {
        selectedDungeon != nil
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 선택된 정보 표시
                    selectedInfoSection

                    // 기록 타입 선택
                    recordTypeSection

                    // 던전 선택
                    dungeonSelectSection

                    // 난이도 선택
                    if selectedDungeon != nil {
                        difficultySelectSection
                    }

                    // 옵션 섹션
                    if selectedDungeon != nil {
                        optionsSection
                    }

                    // 예상 보상 표시
                    if selectedDungeon != nil {
                        rewardSummarySection
                    }

                    // 메모 입력
                    memoSection
                }
                .padding()
            }
            .background(Color.gray.opacity(0.05))
            .navigationTitle("기록 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { saveRecord() }
                        .fontWeight(.semibold)
                        .disabled(!isValid)
                }
            }
            .onChange(of: selectedType) { _, _ in
                // 타입 변경 시 던전 초기화
                selectedDungeon = nil
                selectedDifficulty = selectedType == .conquest ? .normal : .level(1)
                hasMaterialDrop = false
                materialDropCount = 1
            }
            .onChange(of: selectedDungeon) { _, newDungeon in
                // 던전 변경 시 첫 번째 난이도로 설정
                if let first = newDungeon?.stage.first {
                    selectedDifficulty = first.difficulty
                }
            }
        }
    }

    // MARK: - 선택된 정보 섹션
    private var selectedInfoSection: some View {
        HStack(spacing: 16) {
            // 날짜
            VStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(.blue)
                Text(dateString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)

            // 캐릭터
            VStack(spacing: 6) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue)
                Text(characterName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }

    // MARK: - 기록 타입 섹션
    private var recordTypeSection: some View {
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

    // MARK: - 던전 선택 섹션
    private var dungeonSelectSection: some View {
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
                            color: selectedType.color,
                            onTap: { selectedDungeon = dungeon }
                        )
                    }
                }
            }
        }
    }

    // MARK: - 난이도 선택 섹션
    private var difficultySelectSection: some View {
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
                            color: selectedType.color,
                            onTap: { selectedDifficulty = detail.difficulty }
                        )
                    }
                }
            }
        }
    }

    // MARK: - 옵션 섹션
    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("옵션")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                // 두배 보상
                Toggle(isOn: $isDoubleReward) {
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(.yellow)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("두배 보상")
                                .font(.subheadline)
                            Text("구독권 이용자")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(.background)

                Divider()

                // 제작재료 드랍 (정복 던전만, 재료가 있는 경우)
                if selectedType == .conquest && materialInfo != .none {
                    Toggle(isOn: $hasMaterialDrop) {
                        HStack(spacing: 10) {
                            Image(systemName: "cube.fill")
                                .foregroundStyle(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("제작재료 드랍")
                                    .font(.subheadline)
                                Text(materialInfo.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(.background)

                    // 개수 선택
                    if hasMaterialDrop {
                        Divider()

                        HStack {
                            Text("드랍 개수")
                                .font(.subheadline)

                            Spacer()

                            HStack(spacing: 16) {
                                Button(action: {
                                    if materialDropCount > 1 {
                                        materialDropCount -= 1
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(materialDropCount > 1 ? .blue : .gray)
                                }
                                .disabled(materialDropCount <= 1)

                                Text("\(materialDropCount)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .frame(minWidth: 30)

                                Button(action: {
                                    materialDropCount += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        .padding()
                        .background(.background)
                    }

                    Divider()
                }

                // 버스 탑승
                Toggle(isOn: $isBusRide) {
                    HStack(spacing: 10) {
                        Image(systemName: "bus.fill")
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("버스 탑승")
                                .font(.subheadline)
                            Text("다른 유저에게 클리어 도움 받음")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(.background)

                // 버스 요금 입력
                if isBusRide {
                    Divider()

                    HStack {
                        Text("버스 요금")
                            .font(.subheadline)

                        Spacer()

                        HStack(spacing: 4) {
                            TextField("0", text: $busFee)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 120)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .onChange(of: busFee) { _, newValue in
                                    busFee = formatWithComma(newValue)
                                }

                            Text("키나")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(.background)
                }

                Divider()

                // 소요시간 입력
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "clock")
                            .foregroundStyle(.green)
                        Text("소요시간")
                            .font(.subheadline)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        TextField("0", text: $durationMinutes)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 40)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .onChange(of: durationMinutes) { _, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count > 3 {
                                    durationMinutes = String(filtered.prefix(3))
                                } else {
                                    durationMinutes = filtered
                                }
                            }

                        Text("분")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)                    }
                }
                .padding()
                .background(.background)
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }

    // MARK: - 보상 요약 섹션
    private var rewardSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("예상 보상")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                // 메인 보상 (키나 + 재료)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("키나")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 4) {
                            Text("\(formatNumber(calculatedReward))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            if isDoubleReward {
                                Text("x2")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.yellow)
                                    .cornerRadius(4)
                            }
                        }
                    }

                    Spacer()

                    if hasMaterialDrop && materialInfo != .none {
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(materialInfo.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(materialDropCount)개")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.orange)
                        }
                    }
                }
                .padding()

                // 셀렌티움 (부가 보상)
                Divider()

                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "diamond.fill")
                            .font(.caption)
                            .foregroundStyle(.cyan)
                        Text("셀렌티움")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        Text("\(calculatedSelentium)개")
                            .font(.caption)
                            .fontWeight(.medium)
                        Text("(\(formatNumber(selentiumValue)) 키나)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                // 버스 요금 (버스 탑승 시)
                if isBusRide && busFeeValue > 0 {
                    Divider()

                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "bus.fill")
                                .font(.caption)
                                .foregroundStyle(.blue)
                            Text("버스 요금")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text("-\(formatNumber(busFeeValue)) 키나")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.red)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                    // 순수익
                    Divider()

                    HStack {
                        Text("순수익")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text("\(formatNumber(netProfit)) 키나")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(netProfit >= 0 ? .green : .red)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
            .background(.background)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }

    // MARK: - 메모 섹션
    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모 (선택)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            TextField("메모를 입력하세요", text: $memo, axis: .vertical)
                .lineLimit(3...5)
                .padding()
                .background(.background)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }

    // MARK: - 저장
    private func saveRecord() {
        // TODO: 실제 저장 로직 구현
        dismiss()
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private func formatWithComma(_ text: String) -> String {
        // 숫자만 추출
        let digits = text.filter { $0.isNumber }
        guard let number = Int(digits), number > 0 else {
            return digits.isEmpty ? "" : "0"
        }
        // 콤마 포맷 적용
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? digits
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

#Preview {
    RecordCreateView(date: Date(), characterName: "캐릭터1")
}
