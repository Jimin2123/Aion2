//
//  MainTabView.swift
//  Aion
//
//  Created by 정지민 on 2/8/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill", "홈"),
        ("calendar", "캘린더"),
        ("person.2.fill", "캐릭터")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            // 콘텐츠
            Group {
                switch selectedTab {
                case 0: DashboardView()
                case 1: CalendarView()
                case 2: CharacterView()
                default: DashboardView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 커스텀 Footer
            HStack {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = index
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[index].icon)
                                .font(.system(size: 20))
                                .symbolVariant(selectedTab == index ? .fill : .none)

                            Text(tabs[index].label)
                                .font(.caption2)
                                .fontWeight(selectedTab == index ? .semibold : .regular)
                        }
                        .foregroundStyle(selectedTab == index ? .blue : .secondary)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 28)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
