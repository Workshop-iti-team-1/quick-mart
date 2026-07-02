//
//  FetchBrandsUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation
import Combine

protocol FetchBrandsUseCaseProtocol {
    func execute() -> AnyPublisher<[BrandItem], Error>
}

struct FetchBrandsUseCase: FetchBrandsUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[BrandItem], Error> {
        repository.fetchBrands()
    }
}
