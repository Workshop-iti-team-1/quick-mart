//
//  RecentSearchRowView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import SwiftUI

struct RecentSearchRowView: View {

    let query: String
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text(query)
                    .appTextStyle(.body, color: .appBlack)
                Spacer()
                Image(systemName: "arrow.up.left")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.grey150)
            }
            .contentShape(Rectangle())
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        RecentSearchRowView(query: "Smart watch") { }
        Divider()
        RecentSearchRowView(query: "Laptop") { }
    }
    .padding(.horizontal, 16)
}
