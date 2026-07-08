//
//  FetchCategoriesUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation
import Combine

protocol FetchCategoriesUseCaseProtocol {
    func execute() -> AnyPublisher<[CategoryItem], Error>
}

struct FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[CategoryItem], Error> {
        repository.fetchCategories()
    }
}
