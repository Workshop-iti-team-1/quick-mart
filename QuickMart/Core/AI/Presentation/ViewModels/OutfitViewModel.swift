//
//  OutfitViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  OutfitViewModel.swift
//  QuickMart
//
import Foundation

@MainActor
final class OutfitViewModel: ObservableObject {
    let product: ProductDetails
    @Published private(set) var resultText: String?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let useCase: GenerateOutfitUseCaseProtocol

    init(product: ProductDetails, useCase: GenerateOutfitUseCaseProtocol) {
        self.product = product
        self.useCase = useCase
    }

    func generate() {
        guard resultText == nil, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                resultText = try await useCase.execute(product: product)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
