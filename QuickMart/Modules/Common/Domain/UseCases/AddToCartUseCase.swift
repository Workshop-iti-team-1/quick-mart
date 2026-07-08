//
//  AddToCartUseCase.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

protocol AddToCartUseCaseProtocol {
    func execute(variantId: String, quantity: Int) async throws
}

class AddToCartUseCase: AddToCartUseCaseProtocol {
    private let repository: CommonCartRepositoryProtocol
    
    init(repository: CommonCartRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(variantId: String, quantity: Int) async throws {
        try await repository.addToCart(variantId: variantId, quantity: quantity)
    }
}
