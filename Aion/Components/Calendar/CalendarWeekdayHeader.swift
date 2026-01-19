//
//  CalendarWeekdayHeader.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CalendarWeekdayHeader: View {
    private let weekdays = ["일", "월", "화", "수", "목", "금", "토"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekdays.indices, id: \.self) { index in
                Text(weekdays[index])
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(weekdayColor(for: index))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private func weekdayColor(for index: Int) -> Color {
        switch index {
        case 0: return .red      // 일요일
        case 6: return .blue     // 토요일
        default: return .secondary
        }
    }
}

#Preview {
    CalendarWeekdayHeader()
}
