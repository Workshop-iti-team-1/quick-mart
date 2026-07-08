//
//  MockSearchRepository.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

final class MockSearchRepository: SearchRepositoryProtocol {

    private let recentSearchesKey = "com.quickmart.recentSearches.mock"

    // MARK: - Search Products

    func searchProducts(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?) {

        try await Task.sleep(nanoseconds: 300_000_000)
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)

        var results = q.isEmpty
            ? Self.mockProducts
            : Self.mockProducts.filter { $0.name.lowercased().contains(q) }

        if !filters.selectedCategoryIDs.isEmpty {
            results = results.filter {
                !filters.selectedCategoryIDs.isDisjoint(with: $0.categoryHandles)
            }
        }

        if !filters.selectedSubCategoryIDs.isEmpty {
            results = results.filter {
                filters.selectedSubCategoryIDs.contains($0.subCategoryID ?? "")
            }
        }

        if !filters.selectedBrandIDs.isEmpty {
            results = results.filter {
                filters.selectedBrandIDs.contains($0.brandID ?? "")
            }
        }

        switch filters.selectedSort {
        case .priceLowToHigh: results.sort { $0.price < $1.price }
        case .priceHighToLow: results.sort { $0.price > $1.price }
        default: break
        }

        return (products: results, hasNextPage: false, endCursor: nil)
    }

    // MARK: - Sub Categories

    func fetchSubCategories() async throws -> [SubCategory] {
        [
            SubCategory(id: "accessories", name: "Accessories"),
            SubCategory(id: "gift-card",   name: "Gift Card"),
            SubCategory(id: "shoes",       name: "Shoes"),
            SubCategory(id: "snowboard",   name: "Snowboard"),
            SubCategory(id: "t-shirts",    name: "T-Shirts"),
        ]
    }

    // MARK: - Predictive Suggestions

    func fetchPredictiveSuggestions(
        query: String
    ) async throws -> [PredictiveSuggestion] {
        try await Task.sleep(nanoseconds: 150_000_000) // Simulate 0.15s latency

        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return [] }

        // Product suggestions — filter mock products by name
        let productSuggestions: [PredictiveSuggestion] = Self.mockProducts
            .filter { $0.name.lowercased().contains(q) }
            .prefix(5)
            .map { item in
                .product(
                    PredictiveProduct(
                        id: item.id,
                        title: item.name,
                        vendor: item.brandID ?? "",
                        minPrice: item.price,
                        currencyCode: "USD",
                        imageURL: nil
                    )
                )
            }

        // Collection suggestions — filter mock categories by name
        let collectionSuggestions: [PredictiveSuggestion] = Self.mockCollections
            .filter { $0.title.lowercased().contains(q) }
            .prefix(3)
            .map { collection in
                .collection(
                    PredictiveCollection(
                        id: collection.id,
                        title: collection.title,
                        handle: collection.handle,
                        imageURL: nil
                    )
                )
            }

        return productSuggestions + collectionSuggestions
    }

    // MARK: - Recent Searches

    func fetchRecentSearches() -> [String] {
        UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }

    func saveRecentSearch(_ query: String) {
        var searches = fetchRecentSearches()
        searches.removeAll { $0.lowercased() == query.lowercased() }
        searches.insert(query, at: 0)
        UserDefaults.standard.set(
            Array(searches.prefix(10)),
            forKey: recentSearchesKey
        )
    }

    func removeRecentSearch(_ query: String) {
        var searches = fetchRecentSearches()
        searches.removeAll { $0 == query }
        UserDefaults.standard.set(searches, forKey: recentSearchesKey)
    }

    // MARK: - Mock Products

    private static let mockProducts: [ProductSearchItem] = [
        ProductSearchItem(
            id: "1", name: "Loop silicone strong headphones",
            imageName: "headphones", price: 15.25, originalPrice: [20.00],
            colorNames: ["appBlue", "appPurple", "appOrange"], colorCount: 5,
            categoryHandles: ["men", "sale"], subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "2", name: "K800 Ultra smart watch",
            imageName: "applewatch", price: 32.00, originalPrice: [35.00],
            colorNames: ["appBlack", "grey100"], colorCount: 4,
            categoryHandles: ["women"], subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "3", name: "P47 Wireless headphones",
            imageName: "headphones", price: 38.45, originalPrice: [42.75],
            colorNames: ["appBlue", "appBlack", "appRed"], colorCount: 3,
            categoryHandles: ["men"], subCategoryID: "accessories", brandID: "puma"
        ),
        ProductSearchItem(
            id: "4", name: "M6 IP67 headphones",
            imageName: "headphones.circle.fill", price: 12.00, originalPrice: [18.00],
            colorNames: ["appOrange", "grey150"], colorCount: 5,
            categoryHandles: ["women", "sale"], subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "5", name: "D20 Bluetooth smart headphones",
            imageName: "headphones", price: 25.25, originalPrice: [30.00],
            colorNames: ["appBlue", "appBlack", "appYellow"], colorCount: 3,
            categoryHandles: ["kids"], subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "6", name: "D18s Smart headphones",
            imageName: "headphones.circle", price: 17.15, originalPrice: [22.00],
            colorNames: ["grey50"], colorCount: 2,
            categoryHandles: ["sale"], subCategoryID: "accessories", brandID: "puma"
        ),
    ]

    // MARK: - Mock Collections

    private struct MockCollection {
        let id: String
        let title: String
        let handle: String
    }

    private static let mockCollections: [MockCollection] = [
        MockCollection(id: "c1", title: "Men",   handle: "men"),
        MockCollection(id: "c2", title: "Women", handle: "women"),
        MockCollection(id: "c3", title: "Kids",  handle: "kids"),
        MockCollection(id: "c4", title: "Sale",  handle: "sale"),
    ]
}
