//
//  FetchCategoriesUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import Foundation

protocol FetchCategoriesUseCaseProtocol {
    func execute() -> [CategoryItem]
}

struct FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [CategoryItem] {
        repository.fetchCategories()
    }
}
