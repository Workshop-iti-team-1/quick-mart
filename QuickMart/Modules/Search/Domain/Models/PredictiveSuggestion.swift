//
//  PredictiveSuggestion.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 04/07/2026.
//

import Foundation

/// A single autocomplete suggestion shown while the user is typing.
/// Two distinct cases — product and collection — rendered differently
/// in the suggestion list and producing different tap actions.
enum PredictiveSuggestion: Identifiable, Hashable {

    case product(PredictiveProduct)
    case collection(PredictiveCollection)

    var id: String {
        switch self {
        case .product(let p):    return "product-\(p.id)"
        case .collection(let c): return "collection-\(c.id)"
        }
    }
}

// MARK: - Product Suggestion

/// Lightweight product — only what the suggestion row needs.
/// Full ProductSearchItem is loaded when the user commits the search.
struct PredictiveProduct: Identifiable, Hashable {
    let id: String
    let title: String
    let vendor: String
    let minPrice: Double
    let currencyCode: String
    let imageURL: URL?
}

// MARK: - Collection Suggestion

/// Collection suggestion — tapping applies it as a category filter.
/// handle is carried through so it maps directly to selectedCategoryIDs.
struct PredictiveCollection: Identifiable, Hashable {
    let id: String
    let title: String
    let handle: String          // → selectedCategoryIDs in SearchFilters
    let imageURL: URL?
}
