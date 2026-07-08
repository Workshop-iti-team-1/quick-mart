//
//  ProfileRepositoryProtocol.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getCustomerOrders(first: Int, after: String?) async throws -> (orders: [OrderEntity], hasNextPage: Bool, endCursor: String?)
    func getCustomer() async throws -> UserEntity
    func uploadProfileImage(imageData: Data) async throws -> String
}
