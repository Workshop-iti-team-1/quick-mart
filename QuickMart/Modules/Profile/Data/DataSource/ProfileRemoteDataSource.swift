//
//  ProfileRemoteDataSource.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation
import Apollo

protocol ProfileRemoteDataSourceProtocol {
    func getCustomerOrders(first: Int, after: String?) async throws -> ShopifyAPI.GetCustomerOrdersQuery.Data
    func getCustomer() async throws -> ShopifyAPI.GetCustomerQuery.Data
}
class ProfileRemoteDataSourceImpl: ProfileRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol

    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }

    func getCustomerOrders(first: Int, after: String?) async throws -> ShopifyAPI.GetCustomerOrdersQuery.Data {
        let token = SessionManager.shared.getToken() ?? ""
        let query = ShopifyAPI.GetCustomerOrdersQuery(
            customerAccessToken: token,
            first: first,
            after: after ?? .none
        )
        return try await client.performQuery(query: query)
    }

    func getCustomer() async throws -> ShopifyAPI.GetCustomerQuery.Data {
        let token = SessionManager.shared.getToken() ?? ""
        let query = ShopifyAPI.GetCustomerQuery(customerAccessToken: token)
        return try await client.performQuery(query: query)
    }
}
