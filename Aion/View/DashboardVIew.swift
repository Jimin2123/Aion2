//
//  DashBoardView.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    IncomeSummaryCard()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("대시보드")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardView()
}
