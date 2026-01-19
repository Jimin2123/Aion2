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
    case exchange = "거래소"

    var color: Color {
        switch self {
        case .conquest: return .green
        case .transcendence: return .purple
        case .exchange: return .pink
        }
    }

    var icon: String {
        switch self {
        case .conquest: return "shield.fill"
        case .transcendence: return "star.fill"
        case .exchange: return "storefront.fill"
        }
    }
}

enum ExchangeType: String, CaseIterable {
    case world = "월드"
    case local = "일반"

    var taxRate: Int {
        switch self {
        case .world: return GameConstants.world_exchange_tax
        case .local: return GameConstants.local_exchange_tax
        }
    }
}

struct RecordCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: RecordCreateViewModel

    init(date: Date, characterName: String) {
        _viewModel = State(initialValue: RecordCreateViewModel(date: date, characterName: characterName))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 선택된 정보 표시
                    selectedInfoSection

                    // 기록 타입 선택
                    RecordTypeSection(selectedType: $viewModel.selectedType)

                    if viewModel.selectedType == .exchange {
                        // 거래소 전용 섹션
                        ExchangeSection(
                            exchangeType: $viewModel.exchangeType,
                            exchangeItemName: $viewModel.exchangeItemName,
                            exchangePrice: $viewModel.exchangePrice,
                            exchangePriceValue: viewModel.exchangePriceValue,
                            exchangeRegFee: viewModel.exchangeRegFee,
                            exchangeTax: viewModel.exchangeTax,
                            exchangeNetIncome: viewModel.exchangeNetIncome,
                            formatNumber: viewModel.formatNumber,
                            formatWithComma: viewModel.formatWithComma
                        )
                    } else {
                        // 던전 선택
                        DungeonSelectSection(
                            dungeonList: viewModel.dungeonList,
                            selectedDungeon: $viewModel.selectedDungeon,
                            accentColor: viewModel.selectedType.color
                        )

                        // 난이도 선택
                        if viewModel.selectedDungeon != nil {
                            DifficultySelectSection(
                                difficultyOptions: viewModel.difficultyOptions,
                                selectedDifficulty: $viewModel.selectedDifficulty,
                                accentColor: viewModel.selectedType.color
                            )
                        }

                        // 옵션 섹션
                        if viewModel.selectedDungeon != nil {
                            RecordOptionsSection(
                                selectedType: viewModel.selectedType,
                                materialInfo: viewModel.materialInfo,
                                isDoubleReward: $viewModel.isDoubleReward,
                                hasMaterialDrop: $viewModel.hasMaterialDrop,
                                materialDropCount: $viewModel.materialDropCount,
                                isBusRide: $viewModel.isBusRide,
                                busFee: $viewModel.busFee,
                                durationMinutes: $viewModel.durationMinutes,
                                formatWithComma: viewModel.formatWithComma
                            )
                        }

                        // 예상 보상 표시
                        if viewModel.selectedDungeon != nil {
                            RewardSummarySection(
                                calculatedReward: viewModel.calculatedReward,
                                isDoubleReward: viewModel.isDoubleReward,
                                hasMaterialDrop: viewModel.hasMaterialDrop,
                                materialInfo: viewModel.materialInfo,
                                materialDropCount: viewModel.materialDropCount,
                                calculatedSelentium: viewModel.calculatedSelentium,
                                selentiumValue: viewModel.selentiumValue,
                                isBusRide: viewModel.isBusRide,
                                busFeeValue: viewModel.busFeeValue,
                                netProfit: viewModel.netProfit,
                                formatNumber: viewModel.formatNumber
                            )
                        }
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
                    Button("저장") {
                        viewModel.saveRecord()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!viewModel.isValid)
                }
            }
            .onChange(of: viewModel.selectedType) { _, _ in
                viewModel.onTypeChanged()
            }
            .onChange(of: viewModel.selectedDungeon) { _, _ in
                viewModel.onDungeonChanged()
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
                Text(viewModel.dateString)
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
                Text(viewModel.characterName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }

    // MARK: - 메모 섹션
    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모 (선택)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            TextField("메모를 입력하세요", text: $viewModel.memo, axis: .vertical)
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
}

#Preview {
    RecordCreateView(date: Date(), characterName: "캐릭터1")
}
