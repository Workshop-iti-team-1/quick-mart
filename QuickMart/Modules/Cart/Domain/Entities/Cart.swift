//
//  Cart.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

struct Cart: Equatable, Hashable {
    let id: String
    let checkoutUrl: String
    let totalQuantity: Int
    let cost: CartCost
    let lines: [CartLine]
    let discountCodes: [CartDiscountCode]
}

struct CartCost: Equatable,Hashable {
    let subtotalAmount: Double
    let totalAmount: Double
    let totalTaxAmount: Double?
    let currencyCode: String
}

struct CartLine: Equatable, Identifiable,Hashable {
    let id: String
    let quantity: Int
    let cost: CartLineCost
    let merchandise: ProductVariant
}

struct CartLineCost: Equatable,Hashable {
    let totalAmount: Double
    let amountPerQuantity: Double?
    let currencyCode: String
}

struct ProductVariant: Equatable, Identifiable, Hashable {
    let id: String
    let title: String
    let price: Double
    let compareAtPrice: Double?
    let availableForSale: Bool
    let quantityAvailable: Int
    let imageURL: String?
    let productTitle: String
    let productVendor: String
}

struct CartDiscountCode: Equatable,Hashable {
    let code: String
    let applicable: Bool
}
