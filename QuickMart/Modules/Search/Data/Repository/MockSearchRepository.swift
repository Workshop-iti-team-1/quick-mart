//
//  MockSearchRepository.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

// Features/Search/Data/Repositories/MockSearchRepository.swift

import Foundation

final class MockSearchRepository: SearchRepositoryProtocol {

    private let recentSearchesKey = "com.quickmart.recentSearches.mock"

    // MARK: - SearchRepositoryProtocol

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

        // Apply same client-side filter logic for mock parity
        if !filters.selectedCategoryIDs.isEmpty {
            results = results.filter {
                filters.selectedCategoryIDs.contains($0.categoryID ?? "")
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

    func fetchSubCategories() async throws -> [SubCategory] {
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

    // MARK: - Mock Data

    private static let mockProducts: [ProductSearchItem] = [
        ProductSearchItem(
            id: "1", name: "Loop silicone strong headphones",
            imageName: "headphones", price: 15.25, originalPrice: [20.00],
            colorNames: ["appBlue", "appPurple", "appOrange"], colorCount: 5,
            categoryID: "men", subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "2", name: "K800 Ultra smart watch",
            imageName: "applewatch", price: 32.00, originalPrice: [35.00],
            colorNames: ["appBlack", "grey100"], colorCount: 4,
            categoryID: "women", subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "3", name: "P47 Wireless headphones",
            imageName: "headphones", price: 38.45, originalPrice: [42.75],
            colorNames: ["appBlue", "appBlack", "appRed"], colorCount: 3,
            categoryID: "men", subCategoryID: "accessories", brandID: "puma"
        ),
        ProductSearchItem(
            id: "4", name: "M6 IP67 headphones",
            imageName: "headphones.circle.fill", price: 12.00, originalPrice: [18.00],
            colorNames: ["appOrange", "grey150"], colorCount: 5,
            categoryID: "women", subCategoryID: "accessories", brandID: "nike"
        ),
        ProductSearchItem(
            id: "5", name: "D20 Bluetooth smart headphones",
            imageName: "headphones", price: 25.25, originalPrice: [30.00],
            colorNames: ["appBlue", "appBlack", "appYellow"], colorCount: 3,
            categoryID: "kids", subCategoryID: "accessories", brandID: "adidas"
        ),
        ProductSearchItem(
            id: "6", name: "D18s Smart headphones",
            imageName: "headphones.circle", price: 17.15, originalPrice: [22.00],
            colorNames: ["grey50"], colorCount: 2,
            categoryID: "sale", subCategoryID: "accessories", brandID: "puma"
        ),
    ]
}
