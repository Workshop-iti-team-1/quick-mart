//
//  SearchByImageUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  SearchByImageUseCase.swift
//  QuickMart
//
import Foundation

protocol SearchByImageUseCaseProtocol {
    func execute(imageData: Data) async throws -> String
}

struct SearchByImageUseCase: SearchByImageUseCaseProtocol {
    private let repository: AIRepositoryProtocol
    init(repository: AIRepositoryProtocol) { self.repository = repository }

    func execute(imageData: Data) async throws -> String {
        try await repository.searchByImage(imageData)
    }
}
