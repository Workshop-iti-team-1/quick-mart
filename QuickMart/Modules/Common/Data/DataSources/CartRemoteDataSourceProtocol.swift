//
//  CommonRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

protocol CartRemoteDataSourceProtocol {
    func getCart(cartId: String) async throws -> ShopifyAPI.GetCartQuery.Data.Cart?
    func createCart(variantId: String, quantity: Int) async throws -> String?
    func addLine(cartId: String, variantId: String, quantity: Int) async throws
}
