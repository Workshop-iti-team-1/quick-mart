//
//  ShopifyGraphQLClientProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import Foundation

public protocol ShopifyGraphQLClientProtocol {

    func performQuery<T: Decodable>(
        query: String,
        variables: [String: Any]?
    ) async throws -> T
    
    func performMutation<T: Decodable>(
        mutation: String,
        variables: [String: Any]?
    ) async throws -> T
}
