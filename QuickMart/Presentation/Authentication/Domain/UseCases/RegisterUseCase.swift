//
//  RegisterUseCase.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func execute(firstName: String, lastName: String, email: String, password: String, acceptsMarketing: Bool) async throws -> Customer
}

final class RegisterUseCase: RegisterUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(firstName: String, lastName: String, email: String, password: String, acceptsMarketing: Bool) async throws -> Customer {
        return try await repository.register(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            acceptsMarketing: acceptsMarketing
        )
    }
}