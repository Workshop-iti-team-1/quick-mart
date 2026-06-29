//
//  AuthRepositoryProtocol.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

protocol AuthRepositoryProtocol {
    func register(firstName: String, lastName: String, email: String, password: String, acceptsMarketing: Bool) async throws -> Customer
    func login(email: String, password: String) async throws -> AuthToken
}