//
//  SortOption.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//


import Foundation

/// Maps directly to Shopify Storefront API ProductSortKeys + reverse parameter.
/// When GraphQL is wired, pass shopifySortKey and reverseOrder as query variables.
enum SortOption: String, CaseIterable, Identifiable, Hashable {
    case featured       = "Featured"
    case priceLowToHigh = "Price: Low → High"
    case priceHighToLow = "Price: High → Low"
    case bestSelling    = "Best Selling"
    case newest         = "Newest"

    var id: String { rawValue }

    /// Shopify Storefront API ProductSortKeys value
    var shopifySortKey: String {
        switch self {
        case .featured:       return "RELEVANCE"
        case .priceLowToHigh: return "PRICE"
        case .priceHighToLow: return "PRICE"
        case .bestSelling:    return "BEST_SELLING"
        case .newest:         return "CREATED_AT"
        }
    }

    /// Maps to the Shopify `reverse` query parameter
    var reverseOrder: Bool {
        self == .priceHighToLow || self == .newest
    }
}
