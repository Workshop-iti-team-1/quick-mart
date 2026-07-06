//
//  CommonCartRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

class CommonCartRepositoryImpl: CommonCartRepositoryProtocol {
    private let remoteDataSource: CommonCartRemoteDataSourceProtocol
    
    init(remoteDataSource: CommonCartRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func addToCart(variantId: String, quantity: Int) async throws {
        let cartId = UserDefaults.standard.string(forKey: UserDefaultsKeys.cartId) ?? ""
        
        if !cartId.isEmpty {
            do {
               
                let cart = try await remoteDataSource.getCart(cartId: cartId)
                if cart != nil {
              
                    try await remoteDataSource.addLine(cartId: cartId, variantId: variantId, quantity: quantity)
                    return
                } else {
               
                    try await createNewCartAndAdd(variantId: variantId, quantity: quantity)
                }
            } catch {
                
                try await createNewCartAndAdd(variantId: variantId, quantity: quantity)
            }
        } else {
         
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
