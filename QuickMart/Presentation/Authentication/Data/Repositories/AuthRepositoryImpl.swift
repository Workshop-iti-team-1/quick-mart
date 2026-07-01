//
//  AuthRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    
    init(remoteDataSource: AuthRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func register(firstName: String, lastName: String, email: String, password: String, acceptsMarketing: Bool) async throws -> Customer {
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
        let requestDTO = LoginRequestDTO(
            email: email,
            password: password
        )
        
        let tokenDTO = try await remoteDataSource.login(request: requestDTO)
        return tokenDTO.toDomain()
    }
}