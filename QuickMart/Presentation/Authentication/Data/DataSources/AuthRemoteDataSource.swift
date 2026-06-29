//
//  AuthRemoteDataSource.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

protocol AuthRemoteDataSourceProtocol {
    func register(request: RegisterRequestDTO) async throws -> CustomerDTO
    func login(request: LoginRequestDTO) async throws -> AuthTokenDTO
}

final class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol
    
    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }
    
    func register(request: RegisterRequestDTO) async throws -> CustomerDTO {
        let mutation = AuthMutations.register
        
        let variables: [String: Any] = ["input": request.toDictionary()]
        let response: RegisterResponse = try await client.performMutation(mutation: mutation, variables: variables)
        
        let result = response.data.customerCreate
        if let customer = result.customer {
            return customer
        } else if !result.customerUserErrors.isEmpty {
            throw NetworkError.userErrors(result.customerUserErrors)
        } else {
            throw NetworkError.noData
        }
    }
    
    func login(request: LoginRequestDTO) async throws -> AuthTokenDTO {
        let mutation = AuthMutations.login
        
        let variables: [String: Any] = ["input": request.toDictionary()]
        let response: LoginResponse = try await client.performMutation(mutation: mutation, variables: variables)
        
        let result = response.data.customerAccessTokenCreate
        if let token = result.customerAccessToken {
            return token
        } else if !result.customerUserErrors.isEmpty {
            throw NetworkError.userErrors(result.customerUserErrors)
        } else {
            throw NetworkError.noData
        }
    }
}