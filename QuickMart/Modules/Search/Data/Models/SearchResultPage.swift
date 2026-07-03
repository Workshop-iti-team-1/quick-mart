//
//  SearchResultPage.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

/// Raw DTO returned by the Search remote data source.
/// Keeps pagination state together with the product nodes.
/// Mapped to domain models by the Repository layer.
struct SearchResultPage {
    let products: [SearchProductNode]
    let hasNextPage: Bool
    let endCursor: String?
    let totalCount: Int
}

/// One product node from the Shopify search response.
/// Field names mirror the GraphQL schema intentionally —
/// makes Apollo model mapping mechanical and error-free.
struct SearchProductNode {
    let id: String
    let title: String
    let vendor: String          // → brandID filter key
    let productType: String     // → subCategoryID filter key
    let availableForSale: Bool
    let minPrice: Double
    let maxPrice: Double
    let compareAtPrice: [Double]?
    let currencyCode: String
    let imageURL: String?
    let imageAltText: String?
    let collectionHandles: [String] // → categoryID filter keys
    let firstVariantID: String?
}
