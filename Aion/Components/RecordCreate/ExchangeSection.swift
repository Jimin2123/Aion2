//
//  ExchangeSection.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct ExchangeSection: View {
    @Binding var exchangeType: ExchangeType
    @Binding var exchangeItemName: String
    @Binding var exchangePrice: String

    let exchangePriceValue: Int
    let exchangeRegFee: Int
    let exchangeTax: Int
    let exchangeNetIncome: Int

    let formatNumber: (Int) -> String
    let formatWithComma: (String) -> String

    var body: some View {
        VStack(spacing: 16) {
            // 거래소 종류 선택
            exchangeTypeSelector

            // 아이템명 입력
            itemNameInput

            // 판매 가격 입력
            priceInput

            // 수수료 계산 결과
            if exchangePriceValue > 0 {
                settlementSummary
            }
        }
    }

    // MARK: - 거래소 종류 선택
    private var exchangeTypeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("거래소 종류")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Picker("", selection: $exchangeType) {
                ForEach(ExchangeType.allCases, id: \.self) { type in
                    Text("\(type.rawValue) 거래소 (세금 \(type.taxRate)%)").tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - 아이템명 입력
    private var itemNameInput: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("판매 아이템")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            TextField("아이템명을 입력하세요", text: $exchangeItemName)
                .padding()
                .background(.background)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }

    // MARK: - 판매 가격 입력
    private var priceInput: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("판매 가격")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            HStack {
                TextField("0", text: $exchangePrice)
                    .keyboardType(.numberPad)
                    .font(.title3)
                    .fontWeight(.medium)
                    .onChange(of: exchangePrice) { _, newValue in
                        exchangePrice = formatWithComma(newValue)
                    }

                Text("키나")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.background)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }

    // MARK: - 정산 내역
    private var settlementSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("정산 내역")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                // 판매 가격
                HStack {
                    Text("판매 가격")
                        .font(.subheadline)
                    Spacer()
                    Text("\(formatNumber(exchangePriceValue)) 키나")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .background(.background)

                Divider()

                // 등록 수수료
                HStack {
                    Text("등록 수수료 (\(GameConstants.exchange_reg_fee)%)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("-\(formatNumber(exchangeRegFee)) 키나")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.background)

                Divider()

                // 거래소 세금
                HStack {
                    Text("\(exchangeType.rawValue) 거래소 세금 (\(exchangeType.taxRate)%)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("-\(formatNumber(exchangeTax)) 키나")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.background)

                Divider()

                // 실수령액
                HStack {
                    Text("실수령액")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(formatNumber(exchangeNetIncome)) 키나")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
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
}
