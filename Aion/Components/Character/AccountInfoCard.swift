//
//  AccountInfoCard.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct AccountInfoCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("계정 정보").font(.headline)
                }
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill").foregroundStyle(Color.yellow)
                    Text("멤버쉽 구독 중").font(.subheadline).foregroundStyle(Color(.secondaryLabel))
                }
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 25) {
                VStack(spacing: 4) {
                    Text("정복 던전").font(Font.caption).foregroundStyle(Color.secondary)
                    Text("45회").font(Font.system(size: 18, weight: .semibold)).foregroundStyle(Color.green)
                    Text("효율: 100%").font(Font.caption2).foregroundColor(Color.green)
                }
                
                Divider().frame(height: 40)
                
                VStack(spacing: 4) {
                    Text("초월 던전").font(.caption).foregroundStyle(Color.secondary)
                    Text("28회").font(.system(size: 18, weight: .semibold)).foregroundStyle(Color.purple)
                    Text("효율: 100%").font(.caption2).foregroundStyle(Color.purple)
                }
                
                Divider().frame(height: 40)
                
                VStack(spacing: 4) {
                    Text("구독").font(Font.caption).foregroundStyle(Color.secondary)
                    Text("15일").font(Font.system(size: 18, weight: .semibold))
                    Text("남음").font(Font.caption2).foregroundStyle(Color.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y:4)
        .padding(.horizontal)
    }
}

#Preview {
    AccountInfoCard()
}
