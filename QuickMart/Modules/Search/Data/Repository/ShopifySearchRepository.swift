//
//  ShopifySearchRepository.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation
import Combine

final class ShopifySearchRepository: SearchRepositoryProtocol {

    private let remoteDataSource: SearchRemoteDataSourceProtocol
    private let recentSearchesKey = "com.quickmart.recentSearches"
    private let maxRecentSearches = 10

    init(remoteDataSource: SearchRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    // MARK: - SearchRepositoryProtocol

    func searchProducts(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?) {

        let sortKey = filters.selectedSort.shopifySortKey
        let reverse = filters.selectedSort.reverseOrder
        let effectiveQuery = buildQuery(query: query, filters: filters)

        let page: SearchResultPage = try await remoteDataSource
            .searchProducts(
                query: effectiveQuery,
                first: 20,
                after: after,
                sortKey: sortKey,
                reverse: reverse
            )
            .asyncValue()

        let products = page.products.map(Self.mapToDomain)

        return (
            products: products,
            hasNextPage: page.hasNextPage,
            endCursor: page.endCursor
        )
    }

    func fetchSubCategories() async throws -> [SubCategory] {
        let types: [String] = try await remoteDataSource
            .fetchProductTypes(first: 250)
            .asyncValue()

        return types.map { type in
            SubCategory(
                id: type.lowercased().replacingOccurrences(of: " ", with: "-"),
                name: type
            )
        }
    }

    func fetchRecentSearches() -> [String] {
        UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }

    func saveRecentSearch(_ query: String) {
        var searches = fetchRecentSearches()
        searches.removeAll { $0.lowercased() == query.lowercased() }
        searches.insert(query, at: 0)
        UserDefaults.standard.set(
            Array(searches.prefix(maxRecentSearches)),
            forKey: recentSearchesKey
        )
    }

    func removeRecentSearch(_ query: String) {
        var searches = fetchRecentSearches()
        searches.removeAll { $0 == query }
        UserDefaults.standard.set(searches, forKey: recentSearchesKey)
    }

    // MARK: - Query Builder

    private func buildQuery(query: String, filters: SearchFilters) -> String {
        var parts: [String] = []

        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            // Appending the wildcard enables partial-word matching
                parts.append("\(trimmed)*")
        }

        // Fix: quote vendor names to handle spaces and special characters
        // vendor:"Nike" vendor:"Adidas" — correct Shopify syntax
        if !filters.selectedBrandIDs.isEmpty {
            let vendorClauses = filters.selectedBrandIDs
                .map { "vendor:\"\($0)\"" }
                .joined(separator: " OR ")
            parts.append("(\(vendorClauses))")
        }

        if !filters.selectedSubCategoryIDs.isEmpty {
            let typeClauses = filters.selectedSubCategoryIDs
                .map { "product_type:\"\($0)\"" }
                .joined(separator: " OR ")
            parts.append("(\(typeClauses))")
        }

        // Category is handled client-side in the use case
        // Slot ready for server-side collection: filter when Shopify supports it

        return parts.joined(separator: " ")
    }

    // MARK: - Domain Mapping

    private static func mapToDomain(_ node: SearchProductNode) -> ProductSearchItem {
        ProductSearchItem(
            id: node.id,
            name: node.title,
            imageName: node.imageURL ?? "",
            isSystemImage: false,
            price: node.minPrice,
            originalPrice: node.compareAtPrice.map { $0 },
            colorNames: [],
            colorCount: 0,
            isFavorite: false,
            categoryHandles: node.collectionHandles,    // ← ALL handles, not just .first
            subCategoryID: node.productType.isEmpty ? nil : node.productType,
            brandID: node.vendor.isEmpty ? nil : node.vendor
        )
    }
}
