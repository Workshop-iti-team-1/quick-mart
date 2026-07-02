//
//  MockSearchRepository.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

final class MockSearchRepository: SearchRepositoryProtocol {

    private let recentSearchesKey = "com.quickmart.recentSearches"
    private let maxRecentSearches = 10

    // MARK: - SearchRepositoryProtocol

    func searchProducts(query: String, filters: SearchFilters) async throws -> [ProductSearchItem] {
        try await Task.sleep(nanoseconds: 300_000_000) // Simulate 0.3s network latency
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return [] }
        return Self.mockProducts.filter { $0.name.lowercased().contains(q) }
    }

    func fetchSubCategories() async throws -> [SubCategory] {
        // Matches Shopify Storefront API productTypes values
        [
            SubCategory(id: "accessories", name: "Accessories"),
            SubCategory(id: "gift-card",   name: "Gift Card"),
            SubCategory(id: "shoes",       name: "Shoes"),
            SubCategory(id: "snowboard",   name: "Snowboard"),
            SubCategory(id: "t-shirts",    name: "T-Shirts"),
        ]
    }

    func fetchRecentSearches() -> [String] {
        UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }

    func saveRecentSearch(_ query: String) {
        var searches = fetchRecentSearches()
        searches.removeAll { $0.lowercased() == query.lowercased() }
        searches.insert(query, at: 0)
        UserDefaults.standard.set(Array(searches.prefix(maxRecentSearches)), forKey: recentSearchesKey)
    }

    func removeRecentSearch(_ query: String) {
        var searches = fetchRecentSearches()
        searches.removeAll { $0 == query }
        UserDefaults.standard.set(searches, forKey: recentSearchesKey)
    }

    // MARK: - Mock Products
    // categoryID   → collection handle  (Shopify: collection.handle)
    // subCategoryID → product type      (Shopify: product.productType)
    // brandID      → vendor             (Shopify: product.vendor)

    private static let mockProducts: [ProductSearchItem] = [
        ProductSearchItem(
            id: "1", name: "Loop silicone strong headphones",
            imageName: "headphones", price: 15.25, originalPrice: 20.00,
            colorNames: ["appBlue", "appPurple", "appOrange"], colorCount: 5,
            categoryID: "men", subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "2", name: "K800 Ultra smart watch",
            imageName: "applewatch", price: 32.00, originalPrice: 35.00,
            colorNames: ["appBlack", "grey100"], colorCount: 4,
            categoryID: "women", subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "3", name: "P47 Wireless headphones",
            imageName: "headphones", price: 38.45, originalPrice: 42.75,
            colorNames: ["appBlue", "appBlack", "appRed"], colorCount: 3,
            categoryID: "men", subCategoryID: "accessories", brandID: "puma"
        ),
        ProductSearchItem(
            id: "4", name: "M6 IP67 headphones",
            imageName: "headphones.circle.fill", price: 12.00, originalPrice: 18.00,
            colorNames: ["appOrange", "grey150"], colorCount: 5,
            categoryID: "women", subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "5", name: "D20 Bluetooth smart headphones",
            imageName: "headphones", price: 25.25, originalPrice: 30.00,
            colorNames: ["appBlue", "appBlack", "appYellow"], colorCount: 3,
            categoryID: "kids", subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "6", name: "D18s Smart headphones",
            imageName: "headphones.circle", price: 17.15, originalPrice: 22.00,
            colorNames: ["grey50"], colorCount: 2,
            categoryID: "sale", subCategoryID: "accessories", brandID: "puma"
        ),
        ProductSearchItem(
            id: "7", name: "Smart watch Series 6",
            imageName: "applewatch", price: 45.00,
            colorNames: ["appBlack"], colorCount: 1,
            categoryID: "men", subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "8", name: "Laptop Pro 15",
            imageName: "laptopcomputer", price: 999.00, originalPrice: 1199.00,
            colorNames: ["grey50", "appBlack"], colorCount: 2,
            categoryID: "men", subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "9", name: "Women bag leather",
            imageName: "bag.fill", price: 89.99, originalPrice: 120.00,
            colorNames: ["appBrown", "appBlack"], colorCount: 2,
            categoryID: "women", subCategoryID: "accessories", brandID: "puma"
        ),
        ProductSearchItem(
            id: "10", name: "Eye glasses premium",
            imageName: "eyeglasses", price: 55.00, originalPrice: 75.00,
            colorNames: ["appBlack"], colorCount: 1,
            categoryID: "men", subCategoryID: "shoes", brandID: "nike"
        ),
        ProductSearchItem(
            id: "11", name: "Headphones noise cancelling",
            imageName: "headphones", price: 120.00, originalPrice: 150.00,
            colorNames: ["appBlack", "appWhite"], colorCount: 2,
            categoryID: "sale", subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "12", name: "Shoes running sport",
            imageName: "figure.run", price: 65.00, originalPrice: 90.00,
            colorNames: ["appBlue", "appRed"], colorCount: 4,
            categoryID: "men", subCategoryID: "shoes", brandID: "puma"
        ),
    ]
}
