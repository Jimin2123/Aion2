//
//  RewardSummarySection.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct RewardSummarySection: View {
    let calculatedReward: Int
    let isDoubleReward: Bool
    let hasMaterialDrop: Bool
    let materialInfo: RareMaterial
    let materialDropCount: Int
    let calculatedSelentium: Int
    let selentiumValue: Int
    let isBusRide: Bool
    let busFeeValue: Int
    let netProfit: Int

    let formatNumber: (Int) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("예상 보상")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                // 메인 보상 (키나 + 재료)
                mainRewardRow

                // 셀렌티움 (부가 보상)
                Divider()
                selentiumRow

                // 버스 요금 (버스 탑승 시)
                if isBusRide && busFeeValue > 0 {
                    Divider()
                    busFeeRow

                    // 순수익
                    Divider()
                    netProfitRow
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

    // MARK: - 메인 보상
    private var mainRewardRow: some View {
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
    }

    // MARK: - 셀렌티움
    private var selentiumRow: some View {
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
    }

    // MARK: - 버스 요금
    private var busFeeRow: some View {
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
    }

    // MARK: - 순수익
    private var netProfitRow: some View {
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
