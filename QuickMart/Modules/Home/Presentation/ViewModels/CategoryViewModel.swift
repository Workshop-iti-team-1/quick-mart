//
//  CategoryViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import Foundation
import Combine

@MainActor
final class CategoryViewModel: ObservableObject {
    @Published private(set) var categories: [CategoryItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol) {
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }

    func loadCategories() {
        guard categories.isEmpty else { return }
        isLoading = true
        errorMessage = nil

        fetchCategoriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
}
