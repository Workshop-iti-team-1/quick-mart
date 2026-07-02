//
//  BrandViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation
import Combine

@MainActor
final class BrandViewModel: ObservableObject {
    @Published private(set) var brands: [BrandItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let fetchBrandsUseCase: FetchBrandsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(fetchBrandsUseCase: FetchBrandsUseCaseProtocol) {
        self.fetchBrandsUseCase = fetchBrandsUseCase
    }

    func loadBrands() {
        isLoading = true
        errorMessage = nil

        fetchBrandsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] brands in
                self?.brands = brands
            }
            .store(in: &cancellables)
    }
}
