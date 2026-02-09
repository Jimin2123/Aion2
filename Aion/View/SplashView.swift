//
//  SplashView.swift
//  Aion
//
//  Created by 정지민 on 2/8/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoOpacity: Double = 0
    @State private var logoScale: CGFloat = 0.8
    @State private var loadingText = "데이터 불러오는 중..."

    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    // 로고 영역
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 64))
                            .foregroundStyle(.blue)

                        Text("Aion")
                            .font(.system(size: 36, weight: .bold, design: .rounded))

                        Text("아이온 게임 매니저")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(logoOpacity)
                    .scaleEffect(logoScale)

                    Spacer()

                    // 로딩 영역
                    VStack(spacing: 12) {
                        ProgressView()

                        Text(loadingText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(logoOpacity)
                    .padding(.bottom, 60)
                }
            }
            .onAppear {
                // 로고 페이드인 애니메이션
                withAnimation(.easeOut(duration: 0.6)) {
                    logoOpacity = 1.0
                    logoScale = 1.0
                }

                // 데이터 로딩
                loadInitialData()
            }
        }
    }

    private func loadInitialData() {
        Task {
            // TODO: 실제 데이터 로딩 로직
            // - CoreData/SwiftData 초기화 확인
            // - 계정 및 캐릭터 데이터 로드
            // - 에너지/티켓 재충전 시간 계산

            // 최소 표시 시간 (애니메이션 + UX)
            try? await Task.sleep(for: .seconds(1.5))

            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
