//
//  SettingsView.swift
//  Aion
//
//  Created by 정지민 on 2/8/26.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - 알림 설정
    @AppStorage("noti_energyFull") private var notiEnergyFull = true
    @AppStorage("noti_cTicketFull") private var notiCTicketFull = true
    @AppStorage("noti_tTicketFull") private var notiTTicketFull = true
    @AppStorage("noti_dailyReset") private var notiDailyReset = false

    // MARK: - 데이터 관리
    @State private var showResetAlert = false
    @State private var showResetCompleteAlert = false

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "\(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            List {
                // MARK: - 알림
                Section {
                    Toggle("에너지 충전 완료", isOn: $notiEnergyFull)
                    Toggle("정복 티켓 충전 완료", isOn: $notiCTicketFull)
                    Toggle("초월 티켓 충전 완료", isOn: $notiTTicketFull)
                    Toggle("일일 초기화 알림 (05:00)", isOn: $notiDailyReset)
                } header: {
                    Text("알림 설정")
                } footer: {
                    Text("각 캐릭터의 자원이 최대치에 도달하면 알림을 보냅니다.")
                }

                // MARK: - 게임 정보
                Section("게임 정보") {
                    HStack {
                        Text("일일 초기화 시간")
                        Spacer()
                        Text("매일 05:00")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("에너지 충전 주기")
                        Spacer()
                        Text("\(GameConstants.energyRechargeHour)시간")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("정복 티켓 충전 주기")
                        Spacer()
                        Text("\(GameConstants.cDungeonIntervalHour)시간")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("초월 티켓 충전 주기")
                        Spacer()
                        Text("\(GameConstants.tDungeonIntervalHour)시간")
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: - 데이터 관리
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Text("데이터 초기화")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }
                } header: {
                    Text("데이터 관리")
                } footer: {
                    Text("모든 캐릭터 및 던전 기록이 삭제됩니다. 이 작업은 되돌릴 수 없습니다.")
                }

                // MARK: - 앱 정보
                Section("앱 정보") {
                    HStack {
                        Text("앱 버전")
                        Spacer()
                        Text(appVersion)
                            .foregroundStyle(.secondary)
                    }

                    NavigationLink("개인정보 처리방침") {
                        PrivacyPolicyView()
                    }

                    NavigationLink("이용약관") {
                        TermsOfServiceView()
                    }
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .alert("데이터 초기화", isPresented: $showResetAlert) {
                Button("취소", role: .cancel) {}
                Button("초기화", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("모든 데이터가 삭제됩니다. 정말 초기화하시겠습니까?")
            }
            .alert("초기화 완료", isPresented: $showResetCompleteAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("모든 데이터가 초기화되었습니다.")
            }
        }
    }

    private func resetAllData() {
        // TODO: SwiftData/CoreData 초기화 로직 구현
        showResetCompleteAlert = true
    }
}

#Preview {
    SettingsView()
}
