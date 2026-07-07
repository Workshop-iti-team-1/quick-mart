//
//  GenerateInsightsUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  GenerateInsightsUseCase.swift
//  QuickMart
//
import Foundation

protocol GenerateInsightsUseCaseProtocol {
    func execute(orders: [OrderEntity]) async throws -> String
}

struct GenerateInsightsUseCase: GenerateInsightsUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    init(repository: AIRepositoryProtocol) { self.repository = repository }

    func execute(orders: [OrderEntity]) async throws -> String {
        try await repository.generateInsights(orders: orders)
    }
}