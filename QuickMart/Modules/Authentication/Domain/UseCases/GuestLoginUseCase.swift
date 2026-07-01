//
//  GuestLoginUseCase.swift
//  QuickMart
//
//  Created by siam on 30/06/2026.
//

import Foundation

protocol GuestLoginUseCaseProtocol {
    func execute() async throws -> FirebaseUser
}

final class GuestLoginUseCase: GuestLoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> FirebaseUser {
        return try await repository.loginAsGuest()
    }
}
