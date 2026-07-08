//
//  GraphQLClient.swift
//  QuickMart
//
//  Created by siam on 29/06/2026.
//


import Foundation
import Apollo
import ApolloAPI

class TokenInterceptor: ApolloInterceptor {
    var id: String = UUID().uuidString
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        for (key, value) in ShopifyConfig.apolloHeaders {
            request.addHeader(name: key, value: value)
        }
        
        if let token = SessionManager.shared.getToken() {
            request.addHeader(name: "X-Shopify-Customer-Access-Token", value: token)
        }
        
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion
        )
    }
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenInterceptor(), at: 0)
        return interceptors
    }
}

final class GraphQLClient: ShopifyGraphQLClientProtocol {
    private let apollo: ApolloClient
    
    init(apollo: ApolloClient) {
        self.apollo = apollo
    }
    
    // CHANGED: added cachePolicy parameter (defaulted via protocol extension, so old calls
    // like `client.performQuery(query: someQuery)` still compile without any changes)
    func performQuery<Query: GraphQLQuery>(query: Query, cachePolicy: CachePolicy) async throws -> Query.Data {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query, cachePolicy: cachePolicy) { result in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else if let errors = graphQLResult.errors, !errors.isEmpty {
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message ?? "" }.joined(separator: ", ")]))
                    } else {
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data and no errors"]))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // UNCHANGED
    func performMutation<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else if let errors = graphQLResult.errors, !errors.isEmpty {
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: 1, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.message ?? "" }.joined(separator: ", ")]))
                    } else {
                        continuation.resume(throwing: NSError(domain: "GraphQL", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data and no errors"]))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

