//
//  GetCustomerUseCase.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

protocol GetCustomerUseCaseProtocol {
    func execute() async throws -> UserEntity
}

class GetCustomerUseCase: GetCustomerUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> UserEntity {
        return try await repository.getCustomer()
    }
}
