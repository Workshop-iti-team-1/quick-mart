//
//  ShopifyGraphQLClientProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import Foundation
import Apollo
import ApolloAPI


public protocol ShopifyGraphQLClientProtocol {
    func performQuery<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy
    ) async throws -> Query.Data
    
    func performMutation<Mutation: GraphQLMutation>(
        mutation: Mutation
    ) async throws -> Mutation.Data
}

public extension ShopifyGraphQLClientProtocol {
    func performQuery<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch
    ) async throws -> Query.Data {
        try await performQuery(query: query, cachePolicy: cachePolicy)
    }
}
