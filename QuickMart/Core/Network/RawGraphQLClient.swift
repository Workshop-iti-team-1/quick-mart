//
//  RawGraphQLClient.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

final class RawGraphQLClient: ShopifyGraphQLClientProtocol {
    
    init() {}
    
    func performQuery<T: Decodable>(query: String, variables: [String: Any]?) async throws -> T {
        return try await executeRequest(query: query, variables: variables)
    }
    
    func performMutation<T: Decodable>(mutation: String, variables: [String: Any]?) async throws -> T {
        return try await executeRequest(query: mutation, variables: variables)
    }
    
    private func executeRequest<T: Decodable>(query: String, variables: [String: Any]?) async throws -> T {
        var request = URLRequest(url: ShopifyConfig.storeURL)
        request.httpMethod = "POST"
        
        for (key, value) in ShopifyConfig.apolloHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        var body: [String: Any] = ["query": query]
        if let variables = variables {
            body["variables"] = variables
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}