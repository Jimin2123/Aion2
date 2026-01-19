//
//  RecordOptionsSection.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct RecordOptionsSection: View {
    let selectedType: RecordType
    let materialInfo: RareMaterial

    @Binding var isDoubleReward: Bool
    @Binding var hasMaterialDrop: Bool
    @Binding var materialDropCount: Int
    @Binding var isBusRide: Bool
    @Binding var busFee: String
    @Binding var durationMinutes: String

    let formatWithComma: (String) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("옵션")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                // 두배 보상
                doubleRewardToggle

                Divider()

                // 제작재료 드랍 (정복 던전만, 재료가 있는 경우)
                if selectedType == .conquest && materialInfo != .none {
                    materialDropToggle

                    if hasMaterialDrop {
                        Divider()
                        materialCountSelector
                    }

                    Divider()
                }

                // 버스 탑승
                busRideToggle

                if isBusRide {
                    Divider()
                    busFeeInput
                }

                Divider()

                // 소요시간 입력
                durationInput
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }

    // MARK: - 두배 보상 토글
    private var doubleRewardToggle: some View {
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
    }

    // MARK: - 제작재료 드랍 토글
    private var materialDropToggle: some View {
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
    }

    // MARK: - 제작재료 개수 선택
    private var materialCountSelector: some View {
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

    // MARK: - 버스 탑승 토글
    private var busRideToggle: some View {
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
    }

    // MARK: - 버스 요금 입력
    private var busFeeInput: some View {
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

    // MARK: - 소요시간 입력
    private var durationInput: some View {
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
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.background)
    }
}
