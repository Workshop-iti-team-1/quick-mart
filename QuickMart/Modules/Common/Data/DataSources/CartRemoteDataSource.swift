//
//  CommonRemoteDataSource.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

class CartRemoteDataSource: CommonRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol
    
    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }
    
    func getCart(cartId: String) async throws -> ShopifyAPI.GetCartQuery.Data.Cart? {
        let query = ShopifyAPI.GetCartQuery(cartId: cartId)
        let data = try await client.performQuery(query: query, cachePolicy: .fetchIgnoringCacheData)
        return data.cart
    }
    
    func createCart(variantId: String, quantity: Int) async throws -> String? {
        let lines = [ShopifyAPI.CartLineInput(quantity: .some(quantity), merchandiseId: variantId)]
        
        let buyerIdentity = ShopifyAPI.CartBuyerIdentityInput(
            customerAccessToken: SessionManager.shared.getToken() ?? .none
        )
        
        let input = ShopifyAPI.CartInput(
            lines: .some(lines),
            buyerIdentity: .some(buyerIdentity)
        )
        
        let mutation = ShopifyAPI.CreateCartMutation(input: input)
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartCreate?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
        
        return data.cartCreate?.cart?.id
    }
    
    func addLine(cartId: String, variantId: String, quantity: Int) async throws {
        let lines = [ShopifyAPI.CartLineInput(quantity: .some(quantity), merchandiseId: variantId)]
        let mutation = ShopifyAPI.AddCartLinesMutation(cartId: cartId, lines: lines)
        let data = try await client.performMutation(mutation: mutation)
        
        if let errors = data.cartLinesAdd?.userErrors, !errors.isEmpty {
            throw NSError(domain: "Cart", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message }.joined(separator: ", ")])
        }
    }
}
