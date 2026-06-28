//
//  ShopifyGraphQLClientProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import Foundation

public protocol ShopifyGraphQLClientProtocol {
    
    /// Executes a GraphQL query and decodes the response into the expected generic type.
    /// - Parameters:
    ///   - query: The raw GraphQL query string.
    ///   - variables: An optional dictionary of variables mapped to the query.
    /// - Returns: A decoded generic model of type `T`.
    func performQuery<T: Decodable>(
        query: String,
        variables: [String: Any]?
    ) async throws -> T
    
    /// Executes a GraphQL mutation and decodes the response.
    /// - Parameters:
    ///   - mutation: The raw GraphQL mutation string.
    ///   - variables: An optional dictionary of variables mapped to the mutation.
    /// - Returns: A decoded generic model of type `T`.
    func performMutation<T: Decodable>(
        mutation: String,
        variables: [String: Any]?
    ) async throws -> T
}
