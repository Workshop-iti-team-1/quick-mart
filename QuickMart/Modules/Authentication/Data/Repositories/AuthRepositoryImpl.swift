//
//  AuthRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let firebaseAuth: FirebaseAuthServiceProtocol
    
    init(remoteDataSource: AuthRemoteDataSourceProtocol, firebaseAuth: FirebaseAuthServiceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.firebaseAuth = firebaseAuth
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, acceptsMarketing: Bool) async throws -> Customer {
        // 1. Register in Firebase first
        _ = try await firebaseAuth.signUp(email: email, password: password)
        
        // 2. Then register in Shopify
        let requestDTO = RegisterRequestDTO(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            acceptsMarketing: acceptsMarketing
        )
        
        let customerDTO = try await remoteDataSource.register(request: requestDTO)
        return customerDTO.toDomain()
    }
    
    func login(email: String, password: String) async throws -> AuthToken {
        // 1. Sign in to Firebase first
        _ = try await firebaseAuth.signIn(email: email, password: password)
        
        // 2. Then login to Shopify
        let requestDTO = LoginRequestDTO(
            email: email,
            password: password
        )
        
        let tokenDTO = try await remoteDataSource.login(request: requestDTO)
        return tokenDTO.toDomain()
    }
    
    func loginAsGuest() async throws -> FirebaseUser {
        return try await firebaseAuth.signInAnonymously()
    }
    
    func recoverPassword(email: String) async throws {
        // As requested by the user, this is only with Shopify API, not Firebase.
        try await remoteDataSource.recoverPassword(email: email)
    }
}