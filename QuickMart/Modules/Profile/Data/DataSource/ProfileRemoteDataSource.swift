//
//  ProfileRemoteDataSource.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Apollo
import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func getCustomerOrders(first: Int, after: String?) async throws
        -> ShopifyAPI.GetCustomerOrdersQuery.Data
    func getCustomer() async throws -> ShopifyAPI.GetCustomerQuery.Data
    func uploadProfileImage(imageData: Data) async throws -> String
}
class ProfileRemoteDataSourceImpl: ProfileRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol

    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }

    func getCustomerOrders(first: Int, after: String?) async throws
        -> ShopifyAPI.GetCustomerOrdersQuery.Data
    {
        let token = SessionManager.shared.getToken() ?? ""
        let query = ShopifyAPI.GetCustomerOrdersQuery(
            customerAccessToken: token,
            first: first,
            after: after ?? .none
        )
        return try await client.performQuery(
            query: query, cachePolicy: .fetchIgnoringCacheData)
    }

    func getCustomer() async throws -> ShopifyAPI.GetCustomerQuery.Data {
        let token = SessionManager.shared.getToken() ?? ""
        let query = ShopifyAPI.GetCustomerQuery(customerAccessToken: token)
        return try await client.performQuery(query: query)
    }

    func uploadProfileImage(imageData: Data) async throws -> String {
        return try await SupabaseStorageService.shared.uploadImage(
            imageData: imageData)
    }
}
