//
//  HomeViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var banners: [BannerItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

    private let fetchBannersUseCase: FetchBannersUseCaseProtocol

    init(fetchBannersUseCase: FetchBannersUseCaseProtocol) {
        self.fetchBannersUseCase = fetchBannersUseCase
    }

    func loadHome() {
        guard banners.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                banners = try await fetchBannersUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
