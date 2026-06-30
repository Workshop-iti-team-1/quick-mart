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
        query: Query
    ) async throws -> Query.Data
    
    func performMutation<Mutation: GraphQLMutation>(
        mutation: Mutation
    ) async throws -> Mutation.Data
}
