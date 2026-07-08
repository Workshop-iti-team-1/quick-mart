//
//  UploadProfileImageUseCase.swift
//  QuickMart
//
//  Created by siam on 07/07/2026.
//

import Foundation

protocol UploadProfileImageUseCaseProtocol {
    func execute(imageData: Data) async throws -> String
}

class UploadProfileImageUseCase: UploadProfileImageUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(imageData: Data) async throws -> String {
        return try await repository.uploadProfileImage(imageData: imageData)
    }
}
