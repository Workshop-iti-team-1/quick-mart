//
//  CheckoutRepositoryProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import Foundation

protocol CheckoutRepositoryProtocol {

    /// Fetches the Shopify Customer GID using the stored customerAccessToken.
    /// Throws `CheckoutError.notLoggedIn` if no token is available.
    func fetchCustomerId() async throws -> String

    /// Places an order via Shopify Admin API.
    /// - Parameters:
    ///   - cart: Current cart with all line items and cost
    ///   - address: Selected shipping address
    ///   - paymentMethod: Apple Pay or Cash on Delivery
    /// - Returns: Fully populated `PlacedOrder` domain model
    func placeOrder(
        cart: Cart,
        address: Address,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder
}
