//
//  CategoryViewModel.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 29/06/2026.
//

import Foundation

@MainActor
final class CategoryViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var categories: [CategoryItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    // MARK: - Dependency

    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol

    // MARK: - Init

    init(fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }

    // MARK: - Intent

    func loadCategories() {
        isLoading = true
        errorMessage = nil
        categories = fetchCategoriesUseCase.execute()
        isLoading = false
    }
}
