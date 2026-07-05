//
//  CommonRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

class CartRepositoryImpl: CommonRepositoryProtocol {
    private let remoteDataSource: CommonRemoteDataSourceProtocol
    
    init(remoteDataSource: CommonRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func addToCart(variantId: String, quantity: Int) async throws {
        let cartId = UserDefaults.standard.string(forKey: UserDefaultsKeys.cartId) ?? ""
        
        if !cartId.isEmpty {
            do {
                // Try to get cart to verify it exists and is valid
                let cart = try await remoteDataSource.getCart(cartId: cartId)
                if cart != nil {
                    // Valid, so add line
                    try await remoteDataSource.addLine(cartId: cartId, variantId: variantId, quantity: quantity)
                    return
                } else {
                    // Cart not found or invalid
                    try await createNewCartAndAdd(variantId: variantId, quantity: quantity)
                }
            } catch {
                // If it fails (e.g. expired or invalid ID), create a new one
                try await createNewCartAndAdd(variantId: variantId, quantity: quantity)
            }
        } else {
            // No cart ID in local storage
            try await createNewCartAndAdd(variantId: variantId, quantity: quantity)
        }
    }
    
    private func createNewCartAndAdd(variantId: String, quantity: Int) async throws {
        if let newCartId = try await remoteDataSource.createCart(variantId: variantId, quantity: quantity) {
            UserDefaults.standard.set(newCartId, forKey: UserDefaultsKeys.cartId)
        } else {
            throw NSError(domain: "Cart", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create cart."])
        }
    }
}
