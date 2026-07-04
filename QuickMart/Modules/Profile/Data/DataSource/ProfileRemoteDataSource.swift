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
}

class ProfileRemoteDataSourceImpl: ProfileRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol
    
    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }
    
    func getCustomerOrders(first: Int, after: String?) async throws -> ShopifyAPI.GetCustomerOrdersQuery.Data {
        let customerAccessToken = SessionManager.shared.getToken() ?? "" // Retrieve from session
        
        let query = ShopifyAPI.GetCustomerOrdersQuery(
            customerAccessToken: customerAccessToken,
            first: first,
            after: after ?? .none
        )
        
        return try await client.performQuery(query: query)
    }
}
