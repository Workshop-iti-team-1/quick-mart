//
//  GetCurrencyRatesUseCase.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

protocol GetCurrencyRatesUseCaseProtocol {
    func execute() async throws -> CurrencyRateEntity
}

class GetCurrencyRatesUseCase: GetCurrencyRatesUseCaseProtocol {
    private let repository: CurrencyRepositoryProtocol
    
    init(repository: CurrencyRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> CurrencyRateEntity {
        return try await repository.fetchLatestRates()
    }
}
