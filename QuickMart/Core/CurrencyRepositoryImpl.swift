//
//  CurrencyRepository.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

class CurrencyRepositoryImpl: CurrencyRepositoryProtocol {
    private let remoteDataSource: CurrencyRemoteDataSourceProtocol
    
    init(remoteDataSource: CurrencyRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchLatestRates() async throws -> CurrencyRateEntity {
        let dto = try await remoteDataSource.fetchRates()
        return dto.toDomain()
    }
}



