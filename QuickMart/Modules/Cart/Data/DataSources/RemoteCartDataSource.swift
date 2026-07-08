//
//  RemoteCartDataSource.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation
import Apollo

protocol RemoteCartDataSource {
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> ShopifyAPI.UpdateCartLinesMutation.Data.CartLinesUpdate?
    func removeLine(cartId: String, lineId: String) async throws -> ShopifyAPI.RemoveCartLinesMutation.Data.CartLinesRemove?
    func applyDiscount(cartId: String, code: String) async throws -> ShopifyAPI.ApplyDiscountCodeMutation.Data.CartDiscountCodesUpdate?
}

class RemoteCartDataSourceImpl: RemoteCartDataSource {
    private let client: ShopifyGraphQLClientProtocol
    
    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }
    
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> ShopifyAPI.UpdateCartLinesMutation.Data.CartLinesUpdate? {
        let lines = [ShopifyAPI.CartLineUpdateInput(id: lineId, quantity: .some(quantity))]
        let mutation = ShopifyAPI.UpdateCartLinesMutation(cartId: cartId, lines: lines)
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartLinesUpdate?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
        
        return data.cartLinesUpdate
    }
    
    func removeLine(cartId: String, lineId: String) async throws -> ShopifyAPI.RemoveCartLinesMutation.Data.CartLinesRemove? {
        let mutation = ShopifyAPI.RemoveCartLinesMutation(cartId: cartId, lineIds: [lineId])
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartLinesRemove?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
        
        return data.cartLinesRemove
    }
    
    func applyDiscount(cartId: String, code: String) async throws -> ShopifyAPI.ApplyDiscountCodeMutation.Data.CartDiscountCodesUpdate? {
        let mutation = ShopifyAPI.ApplyDiscountCodeMutation(cartId: cartId, discountCodes: [code])
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartDiscountCodesUpdate?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
        
        return data.cartDiscountCodesUpdate
    }
}
