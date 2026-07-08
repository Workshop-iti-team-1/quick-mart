//
//  GenerateOutfitUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

protocol GenerateOutfitUseCaseProtocol {
    func execute(product: ProductDetails) async throws -> [OutfitSuggestionItem]
}

struct GenerateOutfitUseCase: GenerateOutfitUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    init(repository: AIRepositoryProtocol) { self.repository = repository }
    func execute(product: ProductDetails) async throws -> [OutfitSuggestionItem] {
        try await repository.generateOutfitPlan(for: product)
    }
}
