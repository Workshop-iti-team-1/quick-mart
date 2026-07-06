//
//  OrderEntity.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation

struct OrderEntity: Hashable , Identifiable {
    let id: String
    let orderNumber: Int
    let processedAt: Date
    let financialStatus: String
    let fulfillmentStatus: String
    let currentTotalPrice: Double
    let currentSubtotalPrice: Double
    let currencyCode: String
    let discountApplications: [DiscountApplicationEntity]
    let lineItems: [OrderLineItemEntity]
    let shippingAddress: OrderShippingAddressEntity?
    
    var isCompleted: Bool {
        return fulfillmentStatus.uppercased() == "FULFILLED"
    }
}

struct DiscountApplicationEntity: Hashable  {
    let code: String
    let percentage: Double?
    let amount: Double?
}

struct OrderLineItemEntity: Hashable , Identifiable {
    let id: String
    let title: String
    let quantity: Int
    let originalTotalPrice: Double
    let variantTitle: String?
    let imageURL: String?
}

struct OrderShippingAddressEntity: Hashable  {
    let firstName: String?
    let lastName: String?
    let address1: String?
    let city: String?
    let country: String?
    let phone: String?
}
