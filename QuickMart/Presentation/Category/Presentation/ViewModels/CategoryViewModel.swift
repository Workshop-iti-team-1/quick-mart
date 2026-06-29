//
//  CategoryViewModel.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 29/06/2026.
//
// Features/Category/Presentation/ViewModels/CategoryViewModel.swift

import Foundation
import Combine

@MainActor
final class CategoryViewModel: ObservableObject {

    @Published private(set) var categories: [CategoryItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let repository: CategoryRepositoryProtocol

    // No default value — the DIContainer is the sole owner of this decision
    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    func loadCategories() {
        isLoading = true
        errorMessage = nil
        categories = repository.fetchCategories()
        isLoading = false
    }
}
