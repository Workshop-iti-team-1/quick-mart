//
//  FetchSubCategoriesUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

// MARK: - Protocol

protocol FetchSubCategoriesUseCaseProtocol {
    func execute() async throws -> [SubCategory]
}

// MARK: - Implementation

struct FetchSubCategoriesUseCase: FetchSubCategoriesUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [SubCategory] {
        try await repository.fetchSubCategories()
    }
}
