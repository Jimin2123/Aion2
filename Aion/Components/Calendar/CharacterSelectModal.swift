//
//  CharacterSelectModal.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI
import UIKit

struct CharacterSelectModal: View {
    @Binding var isPresented: Bool

    let characters: [String]
    var onSelect: (String) -> Void

    var body: some View {
        ZStack {
            // 배경 딤처리
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPresented = false
                    }
                }

            // 모달 컨텐츠
            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Text("캐릭터 선택")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            isPresented = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()

                Divider()

                // 캐릭터 목록
                VStack(spacing: 8) {
                    ForEach(characters, id: \.self) { character in
                        CharacterSelectRow(
                            name: character,
                            onTap: {
                                onSelect(character)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isPresented = false
                                }
                            }
                        )
                    }
                }
                .padding()
            }
            .background(.background)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - 캐릭터 선택 Row
struct CharacterSelectRow: View {
    let name: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // 캐릭터 아이콘
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.blue)

                // 캐릭터 정보
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    // 간단한 상태 정보 (임시)
                    HStack(spacing: 10) {
                        // 오드 에너지
                        HStack(spacing: 2) {
                            Image(systemName: "bolt.fill")
                                .font(.caption2)
                                .foregroundStyle(.orange)
                            Text("450")
                                .font(.caption2)
                                .foregroundStyle(.primary)
                            Text("+100")
                                .font(.caption2)
                                .foregroundStyle(.blue)
                        }

                        // 정복 티켓
                        HStack(spacing: 2) {
                            Image(systemName: "ticket.fill")
                                .font(.caption2)
                                .foregroundStyle(.green)
                            Text("15")
                                .font(.caption2)
                                .foregroundStyle(.primary)
                            Text("+2")
                                .font(.caption2)
                                .foregroundStyle(.blue)
                        }

                        // 초월 티켓
                        HStack(spacing: 2) {
                            Image(systemName: "ticket.fill")
                                .font(.caption2)
                                .foregroundStyle(.purple)
                            Text("3")
                                .font(.caption2)
                                .foregroundStyle(.primary)
                            Text("+1")
                                .font(.caption2)
                                .foregroundStyle(.blue)
                        }
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - FullScreenCover용 Wrapper (투명 배경 + 중앙 확대 애니메이션)
struct CharacterSelectModalWrapper: View {
    @Binding var isPresented: Bool
    let characters: [String]
    var onSelect: (String) -> Void

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // 배경 딤처리
            Color.black.opacity(isAnimating ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissWithAnimation()
                }

            // 모달 컨텐츠
            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Text("캐릭터 선택")
                        .font(.headline)
                    Spacer()
                    Button(action: dismissWithAnimation) {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()

                Divider()

                // 캐릭터 목록
                VStack(spacing: 8) {
                    ForEach(characters, id: \.self) { character in
                        CharacterSelectRow(
                            name: character,
                            onTap: {
                                onSelect(character)
                                dismissWithAnimation()
                            }
                        )
                    }
                }
                .padding()
            }
            .background(.background)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)
            .scaleEffect(isAnimating ? 1 : 0.8)
            .opacity(isAnimating ? 1 : 0)
        }
        .background {
            TransparentBackground()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                isAnimating = true
            }
        }
    }

    private func dismissWithAnimation() {
        withAnimation(.easeOut(duration: 0.15)) {
            isAnimating = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            isPresented = false
        }
    }
}

// 투명 배경을 위한 UIViewRepresentable
struct TransparentBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = TransparentBackgroundView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

class TransparentBackgroundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        superview?.superview?.backgroundColor = .clear
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3).ignoresSafeArea()

        CharacterSelectModal(
            isPresented: .constant(true),
            characters: ["캐릭터1", "캐릭터2", "캐릭터3"],
            onSelect: { _ in }
        )
    }
}
