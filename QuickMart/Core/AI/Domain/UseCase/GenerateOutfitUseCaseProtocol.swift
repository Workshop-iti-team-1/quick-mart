//
//  GenerateOutfitUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  GenerateOutfitUseCase.swift
//  QuickMart
//
import Foundation

protocol GenerateOutfitUseCaseProtocol {
    func execute(product: ProductDetails) async throws -> String
}

struct GenerateOutfitUseCase: GenerateOutfitUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    private let catalogContextProvider: () -> String

    init(repository: AIRepositoryProtocol, catalogContextProvider: @escaping () -> String) {
        self.repository = repository
        self.catalogContextProvider = catalogContextProvider
    }

    func execute(product: ProductDetails) async throws -> String {
        try await repository.generateOutfit(for: product, catalogContext: catalogContextProvider())
    }
}