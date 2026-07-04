//
//  GetCustomerOrdersUseCase.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation

protocol GetCustomerOrdersUseCaseProtocol {
    func execute(first: Int, after: String?) async throws -> (orders: [OrderEntity], hasNextPage: Bool, endCursor: String?)
}

class GetCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(first: Int, after: String?) async throws -> (orders: [OrderEntity], hasNextPage: Bool, endCursor: String?) {
        return try await repository.getCustomerOrders(first: first, after: after)
    }
}
