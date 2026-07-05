//
//  CheckoutRepositoryImpl.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import Foundation

final class CheckoutRepositoryImpl: CheckoutRepositoryProtocol {

    // MARK: - Dependencies

    private let remoteDataSource: CheckoutRemoteDataSourceProtocol
    private let sessionManager: SessionManager

    // MARK: - Init

    init(
        remoteDataSource: CheckoutRemoteDataSourceProtocol,
        sessionManager: SessionManager = .shared
    ) {
        self.remoteDataSource = remoteDataSource
        self.sessionManager = sessionManager
    }

    // MARK: - CheckoutRepositoryProtocol

    func fetchCustomerId() async throws -> String {
        guard let token = sessionManager.getToken() else {
            throw CheckoutError.notLoggedIn
        }
        return try await remoteDataSource.fetchCustomerId(
            customerAccessToken: token
        )
    }

    func placeOrder(
        cart: Cart,
        address: Address,
        paymentMethod: PaymentMethod
    ) async throws -> PlacedOrder {
        // Fetch customer GID — Admin API requires it, not the access token
        let customerId = try await fetchCustomerId()

        return try await remoteDataSource.placeOrder(
            customerId: customerId,
            cart: cart,
            address: address,
            paymentMethod: paymentMethod
        )
    }
}
