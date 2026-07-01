//
//  FetchBrandsUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//
import Foundation

// MARK: - Protocol

protocol FetchBrandsUseCaseProtocol {
    func execute() -> [BrandItem]
}

// MARK: - Implementation

struct FetchBrandsUseCase: FetchBrandsUseCaseProtocol {

    // MARK: - Dependency

    private let repository: HomeRepositoryProtocol

    // MARK: - Init

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Business Logic

    func execute() -> [BrandItem] {
        repository.fetchBrands()
    }
}
