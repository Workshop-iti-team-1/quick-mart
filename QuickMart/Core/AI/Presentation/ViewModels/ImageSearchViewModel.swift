//
//  ImageSearchViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  ImageSearchViewModel.swift
//  QuickMart
//
import Foundation

@MainActor
final class ImageSearchViewModel: ObservableObject {
    @Published var selectedImageData: Data?
    @Published private(set) var detectedQuery: String?
    @Published private(set) var results: [ProductSearchItem] = []
    @Published private(set) var isAnalyzing: Bool = false
    @Published private(set) var isSearching: Bool = false
    @Published var errorMessage: String?

    private let searchByImageUseCase: SearchByImageUseCaseProtocol
    private let searchProductsUseCase: SearchProductsUseCaseProtocol

    init(searchByImageUseCase: SearchByImageUseCaseProtocol, searchProductsUseCase: SearchProductsUseCaseProtocol) {
        self.searchByImageUseCase = searchByImageUseCase
        self.searchProductsUseCase = searchProductsUseCase
    }

    func analyzeAndSearch(imageData: Data) {
        selectedImageData = imageData
        results = []
        detectedQuery = nil
        errorMessage = nil
        isAnalyzing = true

        Task {
            do {
                let query = try await searchByImageUseCase.execute(imageData: imageData)
                detectedQuery = query
                isAnalyzing = false
                isSearching = true

                let result = try await searchProductsUseCase.execute(query: query, filters: SearchFilters(), after: nil)
                results = result.products
            } catch {
                errorMessage = error.localizedDescription
            }
            isAnalyzing = false
            isSearching = false
        }
    }
}
