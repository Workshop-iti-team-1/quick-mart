//
//  PredictiveSearchDTO.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 04/07/2026.
//

import Foundation

/// Raw DTO returned by the predictive search data source.
/// Maps directly from ShopifyAPI.PredictiveSearchQuery.Data.PredictiveSearch
struct PredictiveSearchResultDTO {
    let products: [PredictiveProductDTO]
    let collections: [PredictiveCollectionDTO]
}

/// Lightweight product node — only fields needed for autocomplete display.
/// Full product data is fetched separately when the user commits the search.
struct PredictiveProductDTO {
    let id: String
    let title: String
    let vendor: String
    let minPrice: Double
    let currencyCode: String
    let imageURL: String?
    let imageAltText: String?
}

/// Collection node returned by predictive search.
/// Used to show category/collection suggestions alongside product suggestions.
struct PredictiveCollectionDTO {
    let id: String
    let title: String
    let handle: String
    let imageURL: String?
    let imageAltText: String?
}
