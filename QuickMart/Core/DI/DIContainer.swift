//
//  DIContainer.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

// App/DI/DIContainer.swift

import Foundation

@MainActor
public final class DIContainer {

    public static let shared = DIContainer()

    private init() {}

    // MARK: - Category

    private func makeCategoryRepository() -> CategoryRepositoryProtocol {
        MockCategoryRepository()
    }

    private func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: makeCategoryRepository())
    }

    func makeCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(fetchCategoriesUseCase: makeFetchCategoriesUseCase())
    }
}
