//
//  CommonRepositoryProtocol.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

protocol CartRepositoryProtocol {
    func addToCart(variantId: String, quantity: Int) async throws
}
