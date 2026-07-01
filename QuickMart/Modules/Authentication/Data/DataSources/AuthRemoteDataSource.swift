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
    func recoverPassword(email: String) async throws
}

final class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol
    
    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }
    
    func register(request: RegisterRequestDTO) async throws -> CustomerDTO {
        let input = ShopifyAPI.CustomerCreateInput(
            firstName: .some(request.firstName ),
            lastName: .some(request.lastName ),
            email: request.email ,
            password: request.password
        )
        let mutation = ShopifyAPI.RegisterCustomerMutation(input: input)
        let response = try await client.performMutation(mutation: mutation)
        
        guard let result = response.customerCreate else {
            throw NetworkError.noData
        }
        
        if let customer = result.customer {
            return CustomerDTO(
                id: customer.id,
                firstName: customer.firstName,
                lastName: customer.lastName,
                email: customer.email ?? ""
            )
        } else if !result.customerUserErrors.isEmpty {
            let errors = result.customerUserErrors.map { error in
                ShopifyUserError(
                    code: error.code?.rawValue,
                    field: error.field,
                    message: error.message
                )
            }
            throw NetworkError.userErrors(errors)
        } else {
            throw NetworkError.noData
        }
    }
    
    func login(request: LoginRequestDTO) async throws -> AuthTokenDTO {
        let input = ShopifyAPI.CustomerAccessTokenCreateInput(
            email: request.email ,
            password: request.password
        )
        let mutation = ShopifyAPI.LoginCustomerMutation(input: input)
        let response = try await client.performMutation(mutation: mutation)
        
        guard let result = response.customerAccessTokenCreate else {
            throw NetworkError.noData
        }
        
        if let token = result.customerAccessToken {
            return AuthTokenDTO(
                accessToken: token.accessToken,
                expiresAt: token.expiresAt
            )
        } else if !result.customerUserErrors.isEmpty {
            let errors = result.customerUserErrors.map { error in
                ShopifyUserError(
                    code: error.code?.rawValue,
                    field: error.field,
                    message: error.message
                )
            }
            throw NetworkError.userErrors(errors)
        } else {
            throw NetworkError.noData
        }
    }
    
    func recoverPassword(email: String) async throws {
        let mutation = ShopifyAPI.RecoverPasswordMutation(email: email)
        let response = try await client.performMutation(mutation: mutation)
        
        guard let result = response.customerRecover else {
            throw NetworkError.noData
        }
        
        if !result.customerUserErrors.isEmpty {
            let errors = result.customerUserErrors.map { error in
                ShopifyUserError(
                    code: error.code?.rawValue,
                    field: error.field,
                    message: error.message
                )
            }
            throw NetworkError.userErrors(errors)
        }
    }
}
