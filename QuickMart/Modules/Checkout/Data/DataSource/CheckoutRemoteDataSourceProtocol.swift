//
//  CheckoutRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//
import Foundation

protocol CheckoutRemoteDataSourceProtocol {

    /// Fetches the Shopify Customer GID using the Storefront API.
    /// Required by Admin API orderCreate which expects a Shopify customer GID,
    /// not the customerAccessToken.
    func fetchCustomerId(customerAccessToken: String) async throws -> String

    /// Places an order via Shopify Admin API orderCreate.
    /// - Parameters:
    ///   - customerId: Shopify Customer GID e.g. "gid://shopify/Customer/123"
    ///   - cart: The current cart containing all line items and cost
    ///   - address: The selected shipping address
    ///   - paymentMethod: Determines financialStatus and transaction inclusion
    /// - Returns: A PlacedOrder domain model
    func placeOrder(
        customerId: String,
        cart: Cart,
        address: Address,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder
}
