//
//  OutfitViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
//

import Foundation

@MainActor
final class OutfitViewModel: ObservableObject {
    let product: ProductDetails
    @Published private(set) var suggestions: [OutfitProductSuggestion] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let generateOutfitUseCase: GenerateOutfitUseCaseProtocol
    private let searchProductsUseCase: SearchProductsUseCaseProtocol

    init(
        product: ProductDetails,
        generateOutfitUseCase: GenerateOutfitUseCaseProtocol,
        searchProductsUseCase: SearchProductsUseCaseProtocol
    ) {
        self.product = product
        self.generateOutfitUseCase = generateOutfitUseCase
        self.searchProductsUseCase = searchProductsUseCase
    }

    // OutfitViewModel.swift
    func generate() {
        guard suggestions.isEmpty, !isLoading else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let plan = try await generateOutfitUseCase.execute(product: product)
                var resolved: [OutfitProductSuggestion] = []

                for item in plan {
                    if let match = await resolveProduct(for: item) {
                        resolved.append(match)
                    }
                }

                suggestions = resolved
                if resolved.isEmpty {
                    errorMessage = "Couldn't find matching items in the catalog right now."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    /// Tries the AI's exact search phrase first, then falls back to progressively
    /// shorter/broader terms (last word, then category name) so a near-miss phrase
    /// still surfaces a real product instead of skipping the piece entirely.
    private func resolveProduct(for item: OutfitSuggestionItem) async -> OutfitProductSuggestion? {
        let candidateQueries = [
            item.searchQuery,
            item.searchQuery.components(separatedBy: " ").last ?? item.searchQuery, // e.g. "jeans"
            item.category // final fallback: broad category name
        ]

        for query in candidateQueries {
            guard let result = try? await searchProductsUseCase.execute(
                query: query, filters: SearchFilters(), after: nil
            ), let match = result.products.first else { continue }

            return OutfitProductSuggestion(
                id: match.id, category: item.category, reason: item.reason, product: match
            )
        }
        return nil
    }
}
