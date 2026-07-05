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

    func fetchCustomerId(customerAccessToken: String) async throws -> String { /// Should be refatored to utilize apollo auto schema generation
        let query = """
        query GetCustomerId($customerAccessToken: String!) {
            customer(customerAccessToken: $customerAccessToken) {
                id
            }
        }
        """

        var request = URLRequest(url: ShopifyConfig.storeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            ShopifyConfig.storefrontToken,
            forHTTPHeaderField: "X-Shopify-Storefront-Access-Token"
        )
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query": query,
            "variables": ["customerAccessToken": customerAccessToken]
        ])

        let (data, response) = try await session.data(for: request)
        try validateHTTPResponse(response)

        guard
            let json        = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let dataObj     = json["data"] as? [String: Any],
            let customer    = dataObj["customer"] as? [String: Any],
            let customerId  = customer["id"] as? String
        else {
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
            "customerId":        customerId,
            "financialStatus":   paymentMethod.shopifyFinancialStatus,
            "lineItems":         lineItems,
            "shippingAddress":   shippingAddress,
            "note":              "Placed via QuickMart iOS — \(paymentMethod.rawValue)"
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

        var request = URLRequest(url: ShopifyConfig.adminURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            ShopifyConfig.adminToken,
            forHTTPHeaderField: "X-Shopify-Access-Token"
        )
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "query":     mutation,
            "variables": ["order": orderInput]
        ])

        let (data, response) = try await session.data(for: request)
        try validateHTTPResponse(response)

        return try parsePlacedOrder(from: data, paymentMethod: paymentMethod, cart: cart)
    }

    // MARK: - Parsing

    private func parsePlacedOrder(
        from data: Data,
        paymentMethod: PaymentMethod,
        cart: Cart
    ) throws -> PlacedOrder {
        guard
            let json        = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let dataObj     = json["data"] as? [String: Any],
            let orderCreate = dataObj["orderCreate"] as? [String: Any]
        else {
            throw CheckoutError.invalidResponse
        }

        // Surface Admin API userErrors before attempting to parse order
        if let userErrors = orderCreate["userErrors"] as? [[String: Any]],
           !userErrors.isEmpty {
            let messages = userErrors
                .compactMap { $0["message"] as? String }
                .joined(separator: "\n")
            throw CheckoutError.orderCreationFailed(messages)
        }

        guard
            let order      = orderCreate["order"] as? [String: Any],
            let id         = order["id"] as? String,
            let name       = order["name"] as? String  // "#1001"
        else {
            throw CheckoutError.invalidResponse
        }

        // name is "#1001" — strip the # and parse to Int
        let orderNumber = Int(name.replacingOccurrences(of: "#", with: "")) ?? 0

        return PlacedOrder(
            id: id,
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
