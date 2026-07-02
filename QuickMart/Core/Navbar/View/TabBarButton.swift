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
                ZStack(alignment: .topTrailing) {
                    Image(systemName: tab.iconName)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? .cyanPrimary : .grayText)
                        .frame(width: 28, height: 28)

                    if tab == .cart && cartCount > 0 {
                        Text("\(cartCount)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.appWhite)
                            .padding(3)
                            .background(Color.appRed)
                            .clipShape(Circle())
                            .offset(x: 8, y: -6)
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