//
//  LoginResponseDTO.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

struct LoginResponse: Decodable {
    let data: LoginData
}
struct LoginData: Decodable {
    let customerAccessTokenCreate: CustomerAccessTokenCreate
}
struct CustomerAccessTokenCreate: Decodable {
    let customerAccessToken: AuthTokenDTO?
    let customerUserErrors: [ShopifyUserError]
}
struct AuthTokenDTO: Decodable {
    let accessToken: String
    let expiresAt: String
    
    func toDomain() -> AuthToken {
        return AuthToken(accessToken: accessToken, expiresAt: expiresAt)
    }
}
