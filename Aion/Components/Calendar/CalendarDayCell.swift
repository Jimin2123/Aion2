//
//  CalendarDayCell.swift
//  Aion
//
//  Created by 정지민 on 1/18/26.
//

import SwiftUI

struct CalendarDayCell: View {
    let date: Date?
    let isToday: Bool
    let isSelected: Bool
    let income: Int?
    let hasRecord: Bool
    var onTap: () -> Void

    private var dayNumber: String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private var weekdayIndex: Int {
        guard let date = date else { return 0 }
        return Calendar.current.component(.weekday, from: date) - 1
    }

    private var dayColor: Color {
        guard date != nil else { return .clear }
        if isSelected { return .white }
        switch weekdayIndex {
        case 0: return .red      // 일요일
        case 6: return .blue     // 토요일
        default: return .primary
        }
    }

    private func formatCompactNumber(_ value: Int) -> String {
        let absValue = abs(value)
        let sign = value < 0 ? "-" : ""

        switch absValue {
        case 1_000_000_000...:
            let formatted = Double(absValue) / 1_000_000_000
            return sign + (formatted.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(formatted))B"
                : String(format: "%.1fB", formatted))
        case 1_000_000...:
            let formatted = Double(absValue) / 1_000_000
            return sign + (formatted.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(formatted))M"
                : String(format: "%.1fM", formatted))
        case 1_000...:
            let formatted = Double(absValue) / 1_000
            return sign + (formatted.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(formatted))K"
                : String(format: "%.1fK", formatted))
        default:
            return sign + "\(absValue)"
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // 날짜 숫자
                Text(dayNumber)
                    .font(.system(size: 18, weight: isToday ? .bold : .regular))
                    .foregroundStyle(dayColor)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : (isToday ? Color.blue.opacity(0.15) : Color.clear))
                    )

                // 수익 정보
                if let income = income, income != 0 {
                    Text(formatCompactNumber(income))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(income > 0 ? .orange : .red)
                } else if hasRecord {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 5, height: 5)
                } else {
                    Color.clear.frame(height: 5)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 65)
        }
        .buttonStyle(.plain)
        .disabled(date == nil)
    }
}

#Preview {
    HStack {
        CalendarDayCell(
            date: Date(),
            isToday: true,
            isSelected: false,
            income: 15_000_000,
            hasRecord: true,
            onTap: {}
        )
        CalendarDayCell(
            date: Date(),
            isToday: false,
            isSelected: true,
            income: nil,
            hasRecord: true,
            onTap: {}
        )
        CalendarDayCell(
            date: Date(),
            isToday: false,
            isSelected: false,
            income: nil,
            hasRecord: false,
            onTap: {}
        )
        CalendarDayCell(
            date: nil,
            isToday: false,
            isSelected: false,
            income: nil,
            hasRecord: false,
            onTap: {}
        )
    }
    .padding()
}
