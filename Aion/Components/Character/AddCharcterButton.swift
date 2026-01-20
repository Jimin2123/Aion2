//
//  AddCharcterButton.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//
import SwiftUI

struct AddCharacterButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.blue)
                Text("캐릭터 추가")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                    .foregroundStyle(.quaternary)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    AddCharacterButton {
        print("캐릭터 추가")
    }
}
