//
//  SearchProductsUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

// Features/Search/Domain/UseCases/SearchProductsUseCase.swift

import Foundation

// MARK: - Protocol

protocol SearchProductsUseCaseProtocol {
    func execute(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?)
}

// MARK: - Implementation

struct SearchProductsUseCase: SearchProductsUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?) {

        var result = try await repository.searchProducts(
            query: query,
            filters: filters,
            after: after
        )

        // Client-side category filtering.
        // Shopify search API doesn't natively support collection: scoping yet.
        // Remove this block once Shopify adds collection-scoped search —
        // the query builder in the repository already has the slot ready.
        if !filters.selectedCategoryIDs.isEmpty {
            result.products = result.products.filter { product in
                guard let categoryID = product.categoryID else { return false }
                return filters.selectedCategoryIDs.contains(categoryID)
            }
        }

        return result
    }
}
