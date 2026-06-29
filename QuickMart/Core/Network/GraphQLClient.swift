//
//  GraphQLClient.swift
//  QuickMart
//
//  Created by siam on 29/06/2026.
//

import Foundation
import Apollo

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
    static let shared = GraphQLClient()
    
    private let apollo: ApolloClient
    
    private init() {
        let store = ApolloStore()
        let provider = NetworkInterceptorProvider(client: URLSessionClient(), store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: ShopifyConfig.storeURL)
        self.apollo = ApolloClient(networkTransport: transport, store: store)
    }
    
    func performQuery<Query: GraphQLQuery>(query: Query) async throws -> Query.Data {
        return try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query) { result in
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
