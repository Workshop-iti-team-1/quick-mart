//
//  OrderSortOption.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 08/07/2026.
//

import Foundation

enum OrderSortOption: String, CaseIterable, Identifiable {
    case newestFirst
    case oldestFirst
    case itemsAscending
    case itemsDescending

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newestFirst: return "Newest → Oldest"
        case .oldestFirst: return "Oldest → Newest"
        case .itemsAscending: return "Number of Items (Low to High)"
        case .itemsDescending: return "Number of Items (High to Low)"
        }
    }

    private func itemCount(for order: OrderEntity) -> Int {
        order.lineItems.reduce(0) { $0 + $1.quantity }
    }

    func sort(_ orders: [OrderEntity]) -> [OrderEntity] {
        switch self {
        case .newestFirst:
            return orders.sorted { $0.processedAt > $1.processedAt }
        case .oldestFirst:
            return orders.sorted { $0.processedAt < $1.processedAt }
        case .itemsAscending:
            return orders.sorted { itemCount(for: $0) < itemCount(for: $1) }
        case .itemsDescending:
            return orders.sorted { itemCount(for: $0) > itemCount(for: $1) }
        }
    }
}
