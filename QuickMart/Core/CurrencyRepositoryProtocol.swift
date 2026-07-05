//
//  CurrencyRepositoryProtocol.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

protocol CurrencyRepositoryProtocol {
    func fetchLatestRates() async throws -> CurrencyRateEntity
}
