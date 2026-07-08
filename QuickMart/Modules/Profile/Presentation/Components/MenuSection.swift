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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ProfileSectionHeader(title: title)
            .padding(.horizontal, 18)

            VStack(spacing: 3) {
                ForEach(items) { item in
                    MenuRow(icon: item.icon, title: item.title, trailing: item.trailing, router: router, onToggleChange: { onToggle(item, $0) })


                    if item.id != items.last?.id { Divider()}
                }
            }
            Divider()
        }
    }
}

