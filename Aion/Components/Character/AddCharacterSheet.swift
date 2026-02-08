//
//  AddCharacterSheet.swift
//  Aion
//
//  Created by 정지민 on 1/20/26.
//

import SwiftUI

struct AddCharacterSheet: View {
    @Bindable var viewModel: CharacterViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    enum Field {
        case name, baseEnergy, chargedEnergy, cTicket, chargedCTicket, tTicket, chargedTTicket
    }

    private var isSubscribed: Bool {
        viewModel.account?.isSubscribed ?? false
    }

    private var maxEnergy: Int {
        isSubscribed ? 840 : 560
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // 캐릭터 이름
                    nameSection

                    // 오드 에너지
                    energySection

                    // 던전 티켓
                    ticketSection

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("캐릭터 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        viewModel.resetNewCharacterFields()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        viewModel.saveNewCharacter()
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.newCharacterName.isEmpty)
                }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }

    // MARK: - Name Section

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "캐릭터 이름", icon: "person.text.rectangle", color: .blue)

            TextField("이름을 입력하세요", text: $viewModel.newCharacterName)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .focused($focusedField, equals: .name)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Energy Section

    private var energySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "오드 에너지", icon: "bolt.fill", color: .orange)

            HStack(spacing: 10) {
                fieldCard(label: "기본", text: $viewModel.newBaseEnergy, suffix: "/ \(maxEnergy)", field: .baseEnergy)
                fieldCard(label: "충전", text: $viewModel.newChargedEnergy, field: .chargedEnergy)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Ticket Section

    private var ticketSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "던전 티켓", icon: "ticket.fill", color: .green)

            // 정복 던전
            ticketRow(
                title: "정복 던전",
                color: .green,
                baseText: $viewModel.newCTicket,
                chargedText: $viewModel.newChargedCTicket,
                maxValue: "21",
                baseField: .cTicket,
                chargedField: .chargedCTicket
            )

            Divider()

            // 초월 던전
            ticketRow(
                title: "초월 던전",
                color: .purple,
                baseText: $viewModel.newTTicket,
                chargedText: $viewModel.newChargedTTicket,
                maxValue: "14",
                baseField: .tTicket,
                chargedField: .chargedTTicket
            )
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Reusable Components

    private func sectionHeader(title: String, icon: String, color: Color) -> some View {
        Label(title, systemImage: icon)
            .font(.callout)
            .fontWeight(.bold)
            .foregroundStyle(color)
    }

    private func fieldCard(
        label: String,
        text: Binding<String>,
        suffix: String? = nil,
        field: Field
    ) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextField("0", text: text)
                .keyboardType(.numberPad)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.trailing)
                .focused($focusedField, equals: field)

            if let suffix {
                Text(suffix)
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func ticketRow(
        title: String,
        color: Color,
        baseText: Binding<String>,
        chargedText: Binding<String>,
        maxValue: String,
        baseField: Field,
        chargedField: Field
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                fieldCard(label: "기본", text: baseText, suffix: "/ \(maxValue)", field: baseField)
                fieldCard(label: "충전", text: chargedText, field: chargedField)
            }
        }
    }
}

#Preview {
    AddCharacterSheet(viewModel: CharacterViewModel())
}
