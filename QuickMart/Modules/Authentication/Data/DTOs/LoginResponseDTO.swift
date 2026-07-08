//
//  LoginResponseDTO.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation


struct AuthTokenDTO: Decodable {
    let accessToken: String
    let expiresAt: String
    
    func toDomain() -> AuthToken {
        return AuthToken(accessToken: accessToken, expiresAt: expiresAt)
    }
}
