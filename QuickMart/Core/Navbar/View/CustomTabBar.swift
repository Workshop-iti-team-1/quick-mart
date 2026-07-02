//
//  CustomTabBar.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    let cartCount: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    cartCount: cartCount,
                    onTap: { selectedTab = tab }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            Color.appWhite
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: -4)
        )
    }
}