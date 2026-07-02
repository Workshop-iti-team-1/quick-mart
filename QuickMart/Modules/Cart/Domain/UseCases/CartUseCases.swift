//
//  CartUseCases.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

protocol CartUseCases {
    func getCart() async throws -> Cart?
    func createCart() async throws -> Cart
    func addLine(variantId: String, quantity: Int) async throws -> Cart
    func updateLine(lineId: String, quantity: Int) async throws -> Cart
    func removeLine(lineId: String) async throws -> Cart
    func applyDiscount(code: String) async throws -> Cart
    func clearCart()
}

class CartUseCasesImpl: CartUseCases {
    private let repository: CartRepository
    
    init(repository: CartRepository) {
        self.repository = repository
    }
    
    func getCart() async throws -> Cart? {
        return try await repository.getCart()
    }
    
    func createCart() async throws -> Cart {
        return try await repository.createCart()
    }
    
    func addLine(variantId: String, quantity: Int) async throws -> Cart {
        return try await repository.addLine(variantId: variantId, quantity: quantity)
    }
    
    func updateLine(lineId: String, quantity: Int) async throws -> Cart {
        return try await repository.updateLine(lineId: lineId, quantity: quantity)
    }
    
    func removeLine(lineId: String) async throws -> Cart {
        return try await repository.removeLine(lineId: lineId)
    }
    
    func applyDiscount(code: String) async throws -> Cart {
        return try await repository.applyDiscount(code: code)
    }
    
    func clearCart() {
        repository.clearCart()
    }
}
