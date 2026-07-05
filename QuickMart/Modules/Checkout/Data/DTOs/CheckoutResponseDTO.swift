//
//  CheckoutResponseDTO.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import Foundation

// MARK: - Storefront: Customer ID Query

struct StorefrontCustomerResponse: Decodable {
    let data: StorefrontCustomerData?
    let errors: [GraphQLErrorMessageDTO]?
}

struct StorefrontCustomerData: Decodable {
    let customer: StorefrontCustomerDTO?
}

struct StorefrontCustomerDTO: Decodable {
    let id: String
}

// MARK: - Admin API: Order Create Mutation

struct AdminOrderCreateResponse: Decodable {
    let data: AdminOrderCreateData?
    let errors: [GraphQLErrorMessageDTO]?
}

struct AdminOrderCreateData: Decodable {
    let orderCreate: AdminOrderCreatePayload
}

struct AdminOrderCreatePayload: Decodable {
    let order: AdminOrderDTO?
    let userErrors: [AdminUserErrorDTO]
}

struct AdminOrderDTO: Decodable {
    let id: String
    let name: String             // "#1001"
    let createdAt: String
    let displayFinancialStatus: String
}

struct AdminUserErrorDTO: Decodable {
    let field: [String]?
    let message: String
}
