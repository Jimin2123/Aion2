//
//  TermsOfServiceView.swift
//  Aion
//
//  Created by 정지민 on 2/8/26.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Group {
                    sectionView(
                        title: "제1조 (목적)",
                        content: """
                        본 약관은 Aion(이하 "앱")의 이용과 관련하여 앱과 이용자 간의 \
                        권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.
                        """
                    )

                    sectionView(
                        title: "제2조 (정의)",
                        content: """
                        • "앱"이란 아이온 게임의 캐릭터, 던전 기록, 수익 등을 관리하기 \
                        위한 보조 도구를 말합니다.
                        • "이용자"란 본 약관에 따라 앱을 이용하는 자를 말합니다.
                        • "콘텐츠"란 앱 내에서 제공되는 게임 정보, 통계, 알림 등을 말합니다.
                        """
                    )

                    sectionView(
                        title: "제3조 (앱의 성격)",
                        content: """
                        앱은 아이온 게임의 공식 서비스가 아닌, 개인이 제작한 비공식 \
                        보조 도구입니다. 게임 내 실제 데이터와 차이가 있을 수 있으며, \
                        앱의 정보를 근거로 한 게임 내 행위에 대해 책임지지 않습니다.
                        """
                    )

                    sectionView(
                        title: "제4조 (이용 계약)",
                        content: """
                        이용자가 앱을 설치하고 사용을 시작한 시점에 본 약관에 동의한 \
                        것으로 간주합니다.
                        """
                    )
                }

                Group {
                    sectionView(
                        title: "제5조 (서비스의 내용)",
                        content: """
                        앱은 다음과 같은 기능을 제공합니다.

                        • 캐릭터별 오드 에너지, 던전 티켓 현황 관리
                        • 정복/초월 던전 기록 및 보상 계산
                        • 일별/월별 수익 통계 및 캘린더
                        • 자원 충전 완료 알림
                        """
                    )

                    sectionView(
                        title: "제6조 (서비스의 변경 및 중단)",
                        content: """
                        앱은 운영상 필요한 경우 서비스의 내용을 변경하거나 중단할 수 \
                        있습니다. 이 경우 앱 업데이트 또는 공지를 통해 안내합니다.
                        """
                    )

                    sectionView(
                        title: "제7조 (이용자의 의무)",
                        content: """
                        이용자는 다음 행위를 하여서는 안 됩니다.

                        • 앱을 역공학, 디컴파일 또는 분해하는 행위
                        • 앱을 이용하여 제3자의 권리를 침해하는 행위
                        • 앱의 정상적인 운영을 방해하는 행위
                        """
                    )

                    sectionView(
                        title: "제8조 (면책 조항)",
                        content: """
                        • 앱은 게임 데이터의 정확성을 보장하지 않습니다.
                        • 게임 업데이트로 인한 수치 변경에 즉시 대응하지 못할 수 있습니다.
                        • 기기 고장, 앱 삭제 등으로 인한 데이터 손실에 대해 책임지지 않습니다.
                        • 앱 사용으로 인한 게임 내 손해에 대해 책임지지 않습니다.
                        """
                    )

                    sectionView(
                        title: "제9조 (약관의 변경)",
                        content: """
                        본 약관은 필요에 따라 변경될 수 있으며, 변경 시 앱 업데이트를 \
                        통해 고지합니다.
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
        .navigationTitle("이용약관")
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
        TermsOfServiceView()
    }
}
