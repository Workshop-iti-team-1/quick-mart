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
    @Published private(set) var latestProducts: [ProductItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil

   
    private let fetchBannersUseCase: FetchBannersUseCaseProtocol
    private let fetchLatestProductsUseCase: FetchLatestProductsUseCaseProtocol

  
    init(
        fetchBannersUseCase: FetchBannersUseCaseProtocol,
        fetchLatestProductsUseCase: FetchLatestProductsUseCaseProtocol
    ) {
        self.fetchBannersUseCase = fetchBannersUseCase
        self.fetchLatestProductsUseCase = fetchLatestProductsUseCase
    }

   
    func loadHome() {
        isLoading = true
        errorMessage = nil
        banners = fetchBannersUseCase.execute()
        latestProducts = fetchLatestProductsUseCase.execute()
        isLoading = false
    }
}
