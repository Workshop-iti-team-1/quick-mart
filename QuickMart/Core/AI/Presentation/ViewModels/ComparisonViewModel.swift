//
//  ComparisonViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  ComparisonViewModel.swift
//  QuickMart
//
import Foundation

@MainActor
final class ComparisonViewModel: ObservableObject {
    let products: [ProductDetails]
    @Published private(set) var resultText: String?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let useCase: CompareProductsUseCaseProtocol

    init(products: [ProductDetails], useCase: CompareProductsUseCaseProtocol) {
        self.products = products
        self.useCase = useCase
    }

    func compare() {
        guard resultText == nil, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                resultText = try await useCase.execute(products: products)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
