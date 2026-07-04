//
//  FetchPredictiveSearchUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 04/07/2026.
//
import Foundation

// MARK: - Protocol

protocol FetchPredictiveSearchUseCaseProtocol {
    func execute(query: String) async throws -> [PredictiveSuggestion]
}

// MARK: - Implementation

struct FetchPredictiveSearchUseCase: FetchPredictiveSearchUseCaseProtocol {

    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [PredictiveSuggestion] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)

        // Guard: Shopify requires at least 1 character for predictive search
        guard !trimmed.isEmpty else { return [] }

        return try await repository.fetchPredictiveSuggestions(query: trimmed)
    }
}
