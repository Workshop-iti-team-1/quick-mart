//
//  DIContainer.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

@MainActor
public final class DIContainer {

    public static let shared = DIContainer()

    private init() {}

    // MARK: - Category

    /// Swap MockCategoryRepository for a real ShopifyCategoryRepository
    /// here when the GraphQL layer is ready — zero changes elsewhere.
    func makeCategoryRepository() -> CategoryRepositoryProtocol {
        MockCategoryRepository()
    }

    func makeCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(repository: makeCategoryRepository())
    }
}
