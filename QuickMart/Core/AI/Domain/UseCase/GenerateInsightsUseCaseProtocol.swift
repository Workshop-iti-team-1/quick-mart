//
//  GenerateInsightsUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


import Foundation

protocol GenerateInsightsUseCaseProtocol {
    func execute(cart: Cart?, orders: [OrderEntity]) async throws -> AIInsightsResult
}

struct GenerateInsightsUseCase: GenerateInsightsUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    init(repository: AIRepositoryProtocol) { self.repository = repository }
    func execute(cart: Cart?, orders: [OrderEntity]) async throws -> AIInsightsResult {
        try await repository.generateInsights(cart: cart, orders: orders)
    }
}

