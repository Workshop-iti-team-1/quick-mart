//
//  CategoryViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation

@MainActor
final class CategoryViewModel: ObservableObject {
    @Published private(set) var categories: [CategoryItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol

    init(fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }

    func loadCategories() {
        isLoading = true
        errorMessage = nil
        categories = fetchCategoriesUseCase.execute()
        isLoading = false
    }
}
