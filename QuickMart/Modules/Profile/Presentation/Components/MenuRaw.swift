//
//  MenuRaw.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//

import SwiftUI

struct MenuRow: View {
    let icon: String
    let title: String
    let trailing: MenuItem.Trailing
    var router: AppRouter
    var onToggleChange: ((Bool) -> Void)? = nil
    @State private var toggleValue: Bool

    init(icon: String, title: String, trailing: MenuItem.Trailing, router: AppRouter, onToggleChange: ((Bool) -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.trailing = trailing
        self.router = router
        self.onToggleChange = onToggleChange
        if case let .toggle(isOn) = trailing {
            _toggleValue = State(initialValue: isOn)
        } else {
            _toggleValue = State(initialValue: false)
        }
    }

    var body: some View {
        Button {
            if case let .chevron(route) = trailing { router.push(route) }
        } label: {
            HStack(spacing: 14) {
                Image(icon).font(.system(size: 24, weight: .medium)).foregroundColor(.grey150)
                Text(title).appTextStyle(.body, color: .grey150)
                Spacer()
                switch trailing {
                case .chevron:
                    Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundColor(.grey150)     .padding(.trailing, 20)
                case .toggle:
                    Toggle("", isOn: $toggleValue).scaleEffect(0.6).labelsHidden().tint(.cyanPrimary)
                        .onChange(of: toggleValue) { newValue in onToggleChange?(newValue) }
                }
            }
            .padding(.leading, 20)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}




struct ProfileSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .appTextStyle(.label, color: .appBlack)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.bottom, 4)
    }
}

