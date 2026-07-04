//
//  FetchBannersUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import Foundation

protocol FetchBannersUseCaseProtocol {
    func execute() async throws -> [BannerItem]
}

struct FetchBannersUseCase: FetchBannersUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [BannerItem] {
        try await repository.fetchBanners()
    }
}

