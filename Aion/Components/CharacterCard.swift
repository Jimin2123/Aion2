//
//  CharacterCard.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CharacterCard: View {
    let name: String
    let baseEnergy: Int
    let maxBaseEnergy: Int
    let chargedEnergy: Int
    let cTicket: Int
    let tTicket: Int
    let totalIncome: Int
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(name).font(.system(size: 18, weight: .semibold))
                Spacer()
                Menu {
                    Button(action: {}) {
                        Label("수정", systemImage: "pencil")
                    }
                    Button(action: {}) {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle").foregroundStyle(.secondary)
                }
            }
            
            // 에너지 정보
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "bolt.fill").font(.system(size: 12)).foregroundStyle(.yellow)
                    Text("오드 에너지").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("\(baseEnergy)/\(maxBaseEnergy)").font(.caption).foregroundColor(.secondary)
                    if chargedEnergy > 0 {
                        Text("+ \(chargedEnergy)").font(.caption).foregroundColor(.blue)
                    }
                }

                ProgressView(value: Double(baseEnergy), total: Double(maxBaseEnergy)).tint(.yellow)
            }
            
            // 티켓과 수익 정보
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "ticket.fill").font(.system(size: 11)).foregroundColor(.green)
                    Text("정복 \(cTicket)").font(.caption)
                }

                HStack(spacing: 4) {
                    Image(systemName: "ticket.fill").font(.system(size: 11)).foregroundColor(.purple)
                    Text("초월 \(tTicket)").font(.caption)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("총 수익(주간)").font(.caption2).foregroundColor(.secondary)
                    Text("\(formatNumber(totalIncome))키나").font(.caption).foregroundColor(.green)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    CharacterCard(
        name: "캐릭터 1",
        baseEnergy: 450,
        maxBaseEnergy: 840,
        chargedEnergy: 120,
        cTicket: 15,
        tTicket: 8,
        totalIncome: 45_000_000
    )
}
