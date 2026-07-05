//
//  PlacedOrder.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import Foundation

struct PlacedOrder : Hashable {
    let id: String               // Shopify GID e.g. "gid://shopify/Order/123"
    let orderNumber: Int         // Human-readable e.g. 1001
    let totalAmount: Double
    let currencyCode: String
    let paymentMethod: PaymentMethod
}
