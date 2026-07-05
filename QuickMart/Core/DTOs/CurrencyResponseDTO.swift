//
//  CurrencyResponseDTO.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

struct CurrencyResponseDTO: Decodable {
    let data:String
    let base:String
    let rates:[String:String]
    
    func toDomain() -> CurrencyRateEntity {
        var parsedRates: [String: Double] = [:]
        for (key, value) in rates {
            if let doubleValue = Double(value) {
                parsedRates[key] = doubleValue
            }
        }
        return CurrencyRateEntity(baseCurrency: base, rates: parsedRates)
    }
}
