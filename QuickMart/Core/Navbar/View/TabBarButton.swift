//
//  TabBarButton.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import SwiftUI

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let cartCount: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                    Image(systemName: tab.iconName)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? .cyanPrimary : .grayText)
                        .frame(width: 28, height: 28)
                        .overlay(alignment: .topTrailing) {
                            if tab == .cart && cartCount > 0 {
                                Text("\(cartCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.appWhite)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .frame(minWidth: 16, minHeight: 16)
                                    .background(Color.cyanPrimary)
                                    .clipShape(Capsule())
                                    .offset(x: 4, y: -4)
                            }
                        }

                Text(tab.title)
                    .appTextStyle(.caption, color: isSelected ? .cyanPrimary : .grayText)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}