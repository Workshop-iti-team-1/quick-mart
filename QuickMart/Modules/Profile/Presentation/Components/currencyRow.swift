//
//  currencyRow.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import SwiftUI

struct CurrencyRowView: View {
    let currency: CurrencyItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(currency.flag)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 4) {
                    Text(currency.code)
                        .appTextStyle(.button, color: .primary)

                    Text(currency.name)
                        .appTextStyle(.label, color: .grey150)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.cyanPrimary)
                        .font(.system(size: 20))
                }
            }
            .padding(16)
            .background(isSelected ? Color.cyanPrimary.opacity(0.1) : Color.grey100.opacity(0.15))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.cyanPrimary.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
