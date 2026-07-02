//
//  CheckboxRowView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import SwiftUI

struct CheckboxRowView: View {

    let title: String
    let isSelected: Bool
    let onToggle: () -> Void

    private enum Layout {
        static let checkboxSize: CGFloat    = 20
        static let cornerRadius: CGFloat    = 4
        static let checkmarkSize: CGFloat   = 11
        static let rowVerticalPad: CGFloat  = 14
        static let spacing: CGFloat         = 12
    }

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: Layout.spacing) {
                checkboxIcon
                Text(title)
                    .appTextStyle(.body, color: .appBlack)
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.vertical, Layout.rowVerticalPad)
        }
        .buttonStyle(.plain)
    }

    private var checkboxIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .fill(isSelected ? Color.cyanPrimary : Color.clear)
                .frame(width: Layout.checkboxSize, height: Layout.checkboxSize)

            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(
                    isSelected ? Color.cyanPrimary : Color.grey150,
                    lineWidth: 1.5
                )
                .frame(width: Layout.checkboxSize, height: Layout.checkboxSize)

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: Layout.checkmarkSize, weight: .bold))
                    .foregroundColor(.appWhite)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 0) {
        CheckboxRowView(title: "Selected", isSelected: true)  { }
        CheckboxRowView(title: "Unselected", isSelected: false) { }
    }
    .padding(.horizontal, 16)
}
