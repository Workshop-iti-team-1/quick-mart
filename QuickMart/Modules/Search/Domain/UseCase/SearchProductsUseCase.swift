//
//  SearchProductsUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

// Features/Search/Domain/UseCases/SearchProductsUseCase.swift

import Foundation

protocol SearchProductsUseCaseProtocol {
    func execute(
        query: String,
        filters: SearchFilters,
        after: String?
    ) async throws -> (products: [ProductSearchItem], hasNextPage: Bool, endCursor: String?)
}

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

        // Client-side category filter.
        // Checks ALL of a product's collection handles against selected category handles.
        // A product passes if ANY of its handles matches ANY selected category (OR logic).
        if !filters.selectedCategoryIDs.isEmpty {
            result.products = result.products.filter { product in
                !Set(product.categoryHandles)
                    .intersection(filters.selectedCategoryIDs)
                    .isEmpty
            }
        }

        return result
    }
}
