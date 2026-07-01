//
//  LoginUseCase.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthToken
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws -> AuthToken {
        return try await repository.login(email: email, password: password)
    }
}