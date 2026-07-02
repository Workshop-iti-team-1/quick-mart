//
//  CartRepository.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

protocol CartRepository {
    func getCart() async throws -> Cart?
    func createCart() async throws -> Cart
    func addLine(variantId: String, quantity: Int) async throws -> Cart
    func updateLine(lineId: String, quantity: Int) async throws -> Cart
    func removeLine(lineId: String) async throws -> Cart
    func applyDiscount(code: String) async throws -> Cart
    func clearCart()
}
