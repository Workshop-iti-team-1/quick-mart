//
//  MenuSection.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//

import SwiftUI

struct MenuSection: View {
    let title: String
    let items: [MenuItem]
    var router: AppRouter
    var onToggle: (MenuItem, Bool) -> Void = { _, _ in }

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ProfileSectionHeader(title: title)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(items) { item in
                    MenuRow(icon: item.icon, title: item.title, trailing: item.trailing, router: router, onToggleChange: { onToggle(item, $0) })
                        .padding(.vertical, 2)

                    if item.id != items.last?.id { 
                        Divider().padding(.leading, 54)
                    }
                }
            }
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.grey100.opacity(colorScheme == .dark ? 0.1 : 0.4), lineWidth: 1)
            )
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

