//
//  PrivacyPolicyView.swift
//  Aion
//
//  Created by 정지민 on 2/8/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Group {
                    sectionView(
                        title: "1. 개인정보의 수집 및 이용 목적",
                        content: """
                        Aion(이하 "앱")은 아이온 게임 플레이를 보조하기 위한 도구로, \
                        다음과 같은 목적으로 정보를 처리합니다.

                        • 캐릭터 정보 관리 (이름, 에너지, 티켓 등)
                        • 던전 기록 및 수익 통계 제공
                        • 알림 설정에 따른 푸시 알림 발송
                        """
                    )

                    sectionView(
                        title: "2. 수집하는 정보 항목",
                        content: """
                        앱은 사용자가 직접 입력하는 다음 정보만을 처리합니다.

                        • 계정 정보: 계정 이름, 구독 여부, 구독 만료일
                        • 캐릭터 정보: 캐릭터 이름, 오드 에너지, 던전 티켓 보유량
                        • 던전 기록: 던전 종류, 난이도, 보상 내역
                        • 앱 설정: 알림 설정값
                        """
                    )

                    sectionView(
                        title: "3. 정보의 저장 및 보관",
                        content: """
                        모든 데이터는 사용자의 기기 내부에만 저장되며, \
                        외부 서버로 전송되지 않습니다.

                        • 저장 방식: 기기 내 로컬 데이터베이스
                        • 보관 기간: 앱 삭제 시 또는 사용자가 데이터를 초기화할 때까지
                        • 서버 전송: 없음
                        """
                    )
                }

                Group {
                    sectionView(
                        title: "4. 제3자 제공",
                        content: """
                        앱은 수집된 정보를 제3자에게 제공하지 않습니다. \
                        외부 광고 SDK, 분석 도구 등을 사용하지 않습니다.
                        """
                    )

                    sectionView(
                        title: "5. 이용자의 권리",
                        content: """
                        사용자는 언제든지 다음 권리를 행사할 수 있습니다.

                        • 데이터 삭제: 설정 > 데이터 관리 > 데이터 초기화
                        • 앱 삭제: 앱 삭제 시 모든 데이터가 기기에서 제거됩니다
                        • 알림 해제: 설정에서 개별 알림을 끌 수 있습니다
                        """
                    )

                    sectionView(
                        title: "6. 개인정보 처리방침의 변경",
                        content: """
                        본 방침이 변경될 경우, 앱 업데이트를 통해 안내합니다. \
                        변경된 방침은 앱 내에서 확인할 수 있습니다.
                        """
                    )

                    sectionView(
                        title: "7. 문의",
                        content: """
                        개인정보 처리와 관련한 문의 사항은 앱스토어 페이지의 \
                        개발자 연락처를 통해 문의해 주시기 바랍니다.
                        """
                    )
                }

                Text("시행일: 2026년 2월 8일")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("개인정보 처리방침")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
