//
//  CurrencyRemoteDataSource.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import Foundation

protocol CurrencyRemoteDataSourceProtocol {
    func fetchRates() async throws -> CurrencyResponseDTO
}

class CurrencyRemoteDataSource: CurrencyRemoteDataSourceProtocol {
    private let client: RestClientProtocol
    private let apiKey: String
    private let baseUrl: String
    
    init(client: RestClientProtocol) {
        self.client = client
        
        guard let key = Bundle.main.object(forInfoDictionaryKey: "CURRENCY_API_KEY") as? String, !key.isEmpty else {
            fatalError("Key CURRENCY_API_KEY is missing or empty in Info.plist")
        }
        guard let url = Bundle.main.object(forInfoDictionaryKey: "CURRENCY_BASE_URL") as? String, !url.isEmpty else {
            fatalError("Key CURRENCY_BASE_URL is missing or empty in Info.plist")
        }
        self.apiKey = key
        self.baseUrl = url.replacingOccurrences(of: "\\", with: "")
    }
    
    func fetchRates() async throws -> CurrencyResponseDTO {
        let endpoint = "/rates/latest?apikey=\(apiKey)"
        return try await client.request(baseUrl: baseUrl, endpoint: endpoint)
    }
}
