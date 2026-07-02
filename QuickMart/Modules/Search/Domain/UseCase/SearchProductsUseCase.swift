//
//  SearchProductsUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

// MARK: - Protocol

protocol SearchProductsUseCaseProtocol {
    func execute(query: String, filters: SearchFilters) async throws -> [ProductSearchItem]
}

// MARK: - Implementation

struct SearchProductsUseCase: SearchProductsUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String, filters: SearchFilters) async throws -> [ProductSearchItem] {
        let raw = try await repository.searchProducts(query: query, filters: filters)
        // Client-side filtering: remove this block when Shopify GraphQL handles it server-side.
        return applyFilters(filters, to: raw)
    }

    // MARK: - Filter Logic
    // Rule: OR within each section, AND across sections.

    private func applyFilters(_ filters: SearchFilters, to products: [ProductSearchItem]) -> [ProductSearchItem] {
        var result = products

        if !filters.selectedCategoryIDs.isEmpty {
            result = result.filter {
                filters.selectedCategoryIDs.contains($0.categoryID ?? "")
            }
        }

        if !filters.selectedSubCategoryIDs.isEmpty {
            result = result.filter {
                filters.selectedSubCategoryIDs.contains($0.subCategoryID ?? "")
            }
        }

        if !filters.selectedBrandIDs.isEmpty {
            result = result.filter {
                filters.selectedBrandIDs.contains($0.brandID ?? "")
            }
        }

        // Client-side sort (bestSelling and newest require server-side ordering)
        switch filters.selectedSort {
        case .priceLowToHigh: result.sort { $0.price < $1.price }
        case .priceHighToLow: result.sort { $0.price > $1.price }
        default: break
        }

        return result
    }
}
