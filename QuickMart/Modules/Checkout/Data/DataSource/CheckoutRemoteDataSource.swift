//
//  CheckoutRemoteDataSource.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import Foundation

final class CheckoutRemoteDataSource: CheckoutRemoteDataSourceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Fetch Customer ID (Storefront API)

    func fetchCustomerId(customerAccessToken: String) async throws -> String {
        let query = """
        query GetCustomerId($customerAccessToken: String!) {
            customer(customerAccessToken: $customerAccessToken) {
                id
            }
        }
        """

        let body: [String: Any] = [
            "query": query,
            "variables": ["customerAccessToken": customerAccessToken]
        ]

        var request = URLRequest(url: ShopifyConfig.storeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            ShopifyConfig.storefrontToken,
            forHTTPHeaderField: "X-Shopify-Storefront-Access-Token"
        )
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        try validateHTTPResponse(response)

        let decoded = try JSONDecoder().decode(
            StorefrontCustomerResponse.self,
            from: data
        )

        if let errors = decoded.errors, !errors.isEmpty {
            throw CheckoutError.orderCreationFailed(
                errors.map(\.message).joined(separator: "\n")
            )
        }

        guard let customerId = decoded.data?.customer?.id else {
            throw CheckoutError.customerNotFound
        }

        return customerId
    }

    // MARK: - Place Order (Admin API)

    func placeOrder(
        customerId: String,
        cart: Cart,
        address: Address,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder {

        let lineItems: [[String: Any]] = cart.lines.map { line in
            [
                "variantId": line.merchandise.id,
                "quantity":  line.quantity
            ]
        }

        let shippingAddress: [String: Any] = [
            "firstName": address.firstName ?? "",
            "lastName":  address.lastName  ?? "",
            "address1":  address.address1  ?? "",
            "city":      address.city      ?? "",
            "province":  address.province  ?? "",
            "country":   address.country   ?? "",
            "zip":       address.zip       ?? "",
            "phone":     address.phone     ?? ""
        ]

        var orderInput: [String: Any] = [
            "customerId":      customerId,
            "financialStatus": paymentMethod.shopifyFinancialStatus,
            "lineItems":       lineItems,
            "shippingAddress": shippingAddress,
            "note":            "Placed via QuickMart iOS — \(paymentMethod.rawValue)"
        ]

        // Apple Pay simulation: include a PAID SALE transaction
        // COD: no transaction — financialStatus PENDING, cash collected on delivery
        if paymentMethod == .applePay {
            let amount = String(format: "%.2f", cart.cost.totalAmount)
            orderInput["transactions"] = [
                [
                    "kind":   "SALE",
                    "status": "SUCCESS",
                    "amountSet": [
                        "shopMoney": [
                            "amount":       amount,
                            "currencyCode": cart.cost.currencyCode
                        ]
                    ]
                ]
            ]
        }

        let mutation = """
        mutation CreateSimulatedOrder($order: OrderCreateOrderInput!) {
            orderCreate(order: $order) {
                order {
                    id
                    name
                    createdAt
                    displayFinancialStatus
                }
                userErrors {
                    field
                    message
                }
            }
        }
        """

        let body: [String: Any] = [
            "query":     mutation,
            "variables": ["order": orderInput]
        ]

        var request = URLRequest(url: ShopifyConfig.adminURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            ShopifyConfig.adminToken,
            forHTTPHeaderField: "X-Shopify-Access-Token"
        )
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        try validateHTTPResponse(response)

        let decoded = try JSONDecoder().decode(
            AdminOrderCreateResponse.self,
            from: data
        )

        // Surface top-level GraphQL errors first
        if let errors = decoded.errors, !errors.isEmpty {
            throw CheckoutError.orderCreationFailed(
                errors.map(\.message).joined(separator: "\n")
            )
        }

        guard let payload = decoded.data?.orderCreate else {
            throw CheckoutError.invalidResponse
        }

        // Surface Admin API userErrors
        if !payload.userErrors.isEmpty {
            let messages = payload.userErrors
                .map(\.message)
                .joined(separator: "\n")
            throw CheckoutError.orderCreationFailed(messages)
        }

        guard let order = payload.order else {
            throw CheckoutError.invalidResponse
        }

        // name is "#1001" — strip # and parse to Int
        let orderNumber = Int(
            order.name.replacingOccurrences(of: "#", with: "")
        ) ?? 0

        return PlacedOrder(
            id: order.id,
            orderNumber: orderNumber,
            totalAmount: cart.cost.totalAmount,
            currencyCode: cart.cost.currencyCode,
            paymentMethod: paymentMethod
        )
    }

    // MARK: - Helpers

    private func validateHTTPResponse(_ response: URLResponse) throws {
        guard
            let http = response as? HTTPURLResponse,
            (200...299).contains(http.statusCode)
        else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw CheckoutError.httpError(code)
        }
    }
}

// MARK: - Checkout Errors

enum CheckoutError: LocalizedError {
    case customerNotFound
    case orderCreationFailed(String)
    case invalidResponse
    case httpError(Int)
    case noAddressSelected
    case notLoggedIn

    var errorDescription: String? {
        switch self {
        case .customerNotFound:
            return "Could not find your account. Please log in again."
        case .orderCreationFailed(let message):
            return message
        case .invalidResponse:
            return "Received an unexpected response. Please try again."
        case .httpError(let code):
            return "Network error (\(code)). Please try again."
        case .noAddressSelected:
            return "Please select a shipping address."
        case .notLoggedIn:
            return "Please log in to complete your order."
        }
    }
}
