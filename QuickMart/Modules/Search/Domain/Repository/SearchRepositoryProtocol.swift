//
//  SearchRepositoryProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchProducts(query: String, filters: SearchFilters) async throws -> [ProductSearchItem]
    func fetchSubCategories() async throws -> [SubCategory]
    func fetchRecentSearches() -> [String]
    func saveRecentSearch(_ query: String)
    func removeRecentSearch(_ query: String)
}
