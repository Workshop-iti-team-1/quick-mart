//
//  CheckoutRemoteDataSource.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//
// Features/Checkout/Data/DataSource/CheckoutRemoteDataSource.swift

import Foundation

final class CheckoutRemoteDataSource: CheckoutRemoteDataSourceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Fetch Customer ID + Email (Storefront API)
    // Returns both ID and email in one call —
    // email is required by Admin API orderCreate to trigger
    // Shopify's native order confirmation email

    func fetchCustomerId(customerAccessToken: String) async throws -> String {
        let (id, _) = try await fetchCustomerDetails(
            customerAccessToken: customerAccessToken
        )
        return id
    }

    /// Internal method that fetches both customer GID and email.
    /// Called by placeOrder so both values are available in one network call.
    private func fetchCustomerDetails(
        customerAccessToken: String
    ) async throws -> (id: String, email: String?) {

        let query = """
        query GetCustomerDetails($customerAccessToken: String!) {
            customer(customerAccessToken: $customerAccessToken) {
                id
                email
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

        guard let customer = decoded.data?.customer else {
            throw CheckoutError.customerNotFound
        }

        return (id: customer.id, email: customer.email)
    }

    // MARK: - Place Order (Admin API)

    func placeOrder(
        customerId: String,
        cart: Cart,
        address: Address,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder {

        // Fetch both customer GID and email in one Storefront call.
        // The email is passed to orderCreate so Shopify's native
        // Order Confirmation notification fires automatically.
        guard let token = SessionManager.shared.getToken() else {
            throw CheckoutError.notLoggedIn
        }

        let (_, customerEmail) = try await fetchCustomerDetails(
            customerAccessToken: token
        )

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

        // ✅ Critical: pass customer email so Shopify fires the
        // native Order Confirmation notification automatically.
        // Without this field, Shopify creates the order silently
        // with no email sent to the customer.
        if let email = customerEmail, !email.isEmpty {
            orderInput["email"] = email
        }

        // Apple Pay simulation: PAID + SALE transaction
        // COD: PENDING, no transaction — cash collected on delivery
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

        if let errors = decoded.errors, !errors.isEmpty {
            throw CheckoutError.orderCreationFailed(
                errors.map(\.message).joined(separator: "\n")
            )
        }

        guard let payload = decoded.data?.orderCreate else {
            throw CheckoutError.invalidResponse
        }

        if !payload.userErrors.isEmpty {
            let messages = payload.userErrors
                .map(\.message)
                .joined(separator: "\n")
            throw CheckoutError.orderCreationFailed(messages)
        }

        guard let order = payload.order else {
            throw CheckoutError.invalidResponse
        }

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
