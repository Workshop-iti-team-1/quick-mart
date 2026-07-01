//
//  FetchLatestProductsUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import Foundation

protocol FetchLatestProductsUseCaseProtocol {
    func execute() -> [ProductItem]
}

struct FetchLatestProductsUseCase: FetchLatestProductsUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> [ProductItem] {
        repository.fetchLatestProducts()
    }
}
