//
//  PlaceOrderUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import Foundation

// MARK: - Protocol

protocol PlaceOrderUseCaseProtocol {
    func execute(
        cart: Cart,
        address: Address?,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder
}

// MARK: - Implementation

struct PlaceOrderUseCase: PlaceOrderUseCaseProtocol {

    private let repository: CheckoutRepositoryProtocol

    init(repository: CheckoutRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        cart: Cart,
        address: Address?,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder {

        // Business rule: address is mandatory before any payment method
        guard let address else {
            throw CheckoutError.noAddressSelected
        }

        return try await repository.placeOrder(
            cart: cart,
            address: address,
            paymentMethod: paymentMethod
        )
    }
}
