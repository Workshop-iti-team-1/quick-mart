//
//  PaymentMethod.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable, Hashable {
    case applePay       = "Apple Pay"
    case cashOnDelivery = "Cash on Delivery"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .applePay:       return "applelogo"
        case .cashOnDelivery: return "banknote"
        }
    }

    /// Admin API financialStatus value
    var shopifyFinancialStatus: String {
        switch self {
        case .applePay:       return "PAID"
        case .cashOnDelivery: return "PENDING"
        }
    }
}
