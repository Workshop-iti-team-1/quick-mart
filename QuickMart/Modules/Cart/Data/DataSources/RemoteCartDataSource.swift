//
//  RemoteCartDataSource.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation
import Apollo

protocol RemoteCartDataSource {
    func getCart(cartId: String) async throws -> ShopifyAPI.GetCartQuery.Data.Cart?
    func createCart(variantId: String?, quantity: Int?) async throws -> ShopifyAPI.CreateCartMutation.Data.CartCreate?
    func addLine(cartId: String, variantId: String, quantity: Int) async throws -> ShopifyAPI.AddCartLinesMutation.Data.CartLinesAdd?
    func updateLine(cartId: String, lineId: String, quantity: Int) async throws -> ShopifyAPI.UpdateCartLinesMutation.Data.CartLinesUpdate?
    func removeLine(cartId: String, lineId: String) async throws -> ShopifyAPI.RemoveCartLinesMutation.Data.CartLinesRemove?
    func applyDiscount(cartId: String, code: String) async throws -> ShopifyAPI.ApplyDiscountCodeMutation.Data.CartDiscountCodesUpdate?
}

class RemoteCartDataSourceImpl: RemoteCartDataSource {
    private let client: ShopifyGraphQLClientProtocol
    
    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }
    
    func getCart(cartId: String) async throws -> ShopifyAPI.GetCartQuery.Data.Cart? {
        let query = ShopifyAPI.GetCartQuery(cartId: cartId)
        let data = try await client.performQuery(query: query)
        return data.cart
    }
    
    func createCart(variantId: String? = nil, quantity: Int? = nil) async throws -> ShopifyAPI.CreateCartMutation.Data.CartCreate? {
        var lines: [ShopifyAPI.CartLineInput]? = nil
        if let variantId = variantId, let quantity = quantity {
            lines = [ShopifyAPI.CartLineInput(quantity: .some(quantity), merchandiseId: variantId)]
        }
        
        let buyerIdentity = ShopifyAPI.CartBuyerIdentityInput(
            customerAccessToken: SessionManager.shared.getToken() ?? .none
        )
        
        let input = ShopifyAPI.CartInput(
            lines: lines ?? .none,
            buyerIdentity: .some(buyerIdentity)
        )
        
        let mutation = ShopifyAPI.CreateCartMutation(input: input)
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartCreate?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
        
        return data.cartCreate
    }
    
    func addLine(cartId: String, variantId: String, quantity: Int) async throws -> ShopifyAPI.AddCartLinesMutation.Data.CartLinesAdd? {
        let lines = [ShopifyAPI.CartLineInput(quantity: .some(quantity), merchandiseId: variantId)]
        let mutation = ShopifyAPI.AddCartLinesMutation(cartId: cartId, lines: lines)
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartLinesAdd?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
        
        return data.cartLinesAdd
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
