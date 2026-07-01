//
//  RecoverPasswordUseCase.swift
//  QuickMart
//
//  Created by siam on 30/06/2026.
//

import Foundation

protocol RecoverPasswordUseCaseProtocol {
    func execute(email: String) async throws
}

struct AuthValidationError: LocalizedError {
    let errorDescription: String?
}

final class RecoverPasswordUseCase: RecoverPasswordUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String) async throws {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthValidationError(errorDescription: AppStrings.Auth.Validation.emptyEmailPassword)
        }
        
        guard email.isValidEmail else {
            throw AuthValidationError(errorDescription: AppStrings.Auth.Validation.invalidEmail)
        }
        
        try await repository.recoverPassword(email: email)
    }
}
