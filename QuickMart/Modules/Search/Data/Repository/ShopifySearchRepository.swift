//
//  ShopifySearchRepository.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation
import Combine

final class ShopifySearchRepository: SearchRepositoryProtocol {

    // MARK: - Dependencies

    private let remoteDataSource: SearchRemoteDataSourceProtocol
    private let recentSearchesKey = "com.quickmart.recentSearches"
    private let maxRecentSearches = 10

    // MARK: - Init

    init(remoteDataSource: SearchRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    // MARK: - SearchRepositoryProtocol

    func searchProducts(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?) {

        // Map SortOption → Shopify API parameters
        let sortKey = filters.selectedSort.shopifySortKey
        let reverse = filters.selectedSort.reverseOrder

        // Empty query string fetches all products via Shopify search
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
    // Builds a Shopify search query string that combines free text
    // with vendor/product_type filters.
    // Format: "shoes vendor:nike product_type:accessories"
    //
    // When Shopify adds collection-scoped search, collection handles
    // slot in here — zero ViewModel changes required.

    private func buildQuery(query: String, filters: SearchFilters) -> String {
        var parts: [String] = []

        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            parts.append(trimmed)
        }

        // OR within brands: vendor:nike OR vendor:adidas
        if !filters.selectedBrandIDs.isEmpty {
            let vendorClauses = filters.selectedBrandIDs
                .map { "vendor:\($0)" }
                .joined(separator: " OR ")
            parts.append("(\(vendorClauses))")
        }

        // OR within sub-categories: product_type:shoes OR product_type:accessories
        if !filters.selectedSubCategoryIDs.isEmpty {
            let typeClauses = filters.selectedSubCategoryIDs
                .map { "product_type:\($0)" }
                .joined(separator: " OR ")
            parts.append("(\(typeClauses))")
        }

        // Category filtering via collection handles
        // Shopify search doesn't support collection: filter natively yet —
        // collectionHandles on ProductSearchItem enables client-side filtering
        // in SearchProductsUseCase until server-side support lands.

        return parts.joined(separator: " ")
    }

    // MARK: - Domain Mapping
    // SearchProductNode (DTO) → ProductSearchItem (domain)

    private static func mapToDomain(_ node: SearchProductNode) -> ProductSearchItem {
        ProductSearchItem(
            id: node.id,
            name: node.title,
            imageName: node.imageURL ?? "",
            isSystemImage: false,
            price: node.minPrice,
            // Wrap into array; SearchProductNode carries min compareAt only.
            // When max compareAt is needed, add node.maxCompareAtPrice as second element.
            originalPrice: node.compareAtPrice.map { $0 },
            colorNames: [],
            colorCount: 0,
            isFavorite: false,
            categoryID: node.collectionHandles.first,
            subCategoryID: node.productType.isEmpty ? nil : node.productType,
            brandID: node.vendor.isEmpty ? nil : node.vendor
        )
    }
}
