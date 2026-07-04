//
//  MenuItem.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//

import Foundation

struct MenuItem: Identifiable {
    enum Trailing {
        case chevron(route: Route)
        case toggle(isOn: Bool)
    }
    let id = UUID()
    let icon: String
    let title: String
    let trailing: Trailing
}
