//
//  GetProductDetailsUseCase.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

protocol GetProductDetailsUseCaseProtocol {
    func execute(id: String) async throws -> ProductDetails
}

final class GetProductDetailsUseCase: GetProductDetailsUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: String) async throws -> ProductDetails {
        return try await repository.getProductDetails(id: id)
    }
}
