//
//  BrandViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation

@MainActor
final class BrandViewModel: ObservableObject {

    // MARK: - Published State

    @Published private(set) var brands: [BrandItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    // MARK: - Dependency

    private let fetchBrandsUseCase: FetchBrandsUseCaseProtocol

    // MARK: - Init

    init(fetchBrandsUseCase: FetchBrandsUseCaseProtocol) {
        self.fetchBrandsUseCase = fetchBrandsUseCase
    }

    // MARK: - Intent

    func loadBrands() {
        isLoading = true
        errorMessage = nil
        brands = fetchBrandsUseCase.execute()
        isLoading = false
    }
}
