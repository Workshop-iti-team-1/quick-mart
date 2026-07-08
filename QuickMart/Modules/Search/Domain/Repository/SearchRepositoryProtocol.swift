//
//  SearchRepositoryProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchProducts(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (
        products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?
    )
    
    func fetchPredictiveSuggestions(
        query: String
    ) async throws -> [PredictiveSuggestion]
    func fetchSubCategories() async throws -> [SubCategory]
    func fetchRecentSearches() -> [String]
    func saveRecentSearch(_ query: String)
    func removeRecentSearch(_ query: String)
}
