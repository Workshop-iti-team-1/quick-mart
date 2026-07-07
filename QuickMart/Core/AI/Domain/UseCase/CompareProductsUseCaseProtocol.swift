//
//  CompareProductsUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  CompareProductsUseCase.swift
//  QuickMart
//
import Foundation

protocol CompareProductsUseCaseProtocol {
    func execute(products: [ProductDetails]) async throws -> String
}

struct CompareProductsUseCase: CompareProductsUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    init(repository: AIRepositoryProtocol) { self.repository = repository }

    func execute(products: [ProductDetails]) async throws -> String {
        try await repository.compareProducts(products)
    }
}