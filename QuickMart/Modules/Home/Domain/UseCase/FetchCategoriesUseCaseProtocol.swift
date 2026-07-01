//
//  FetchCategoriesUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


//
//  FetchCategoriesUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 29/06/2026.

import Foundation

// MARK: - Protocol

protocol FetchCategoriesUseCaseProtocol {
    func execute() -> [CategoryItem]
}

// MARK: - Implementation

struct FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {

    // MARK: - Dependency

    private let repository: CategoryRepositoryProtocol

    // MARK: - Init

    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Business Logic

    func execute() -> [CategoryItem] {
        repository.fetchCategories()
    }
}
