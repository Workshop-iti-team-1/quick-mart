//
//  CurrencyManagerSrevice.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import Foundation
import SwiftUI

@MainActor
class CurrencyManagerService: ObservableObject {
    @Published var rates: [String: Double] = [:]
    @AppStorage("selectedCurrency") var selectedCurrency: String = AppConstants
        .defultAppCurrency
    private let getRatesUseCase: GetCurrencyRatesUseCaseProtocol

    init(getRatesUseCase: GetCurrencyRatesUseCaseProtocol) {
        self.getRatesUseCase = getRatesUseCase
    }
    func loadRatesIfNeeded() async {
        guard selectedCurrency != AppConstants.defultAppCurrency else {
            print("Default currency is USD -> API call skipped")
            return
        }
        guard rates.isEmpty else { return }

        do {
            let entity = try await getRatesUseCase.execute()
            self.rates = entity.rates
            print("Currency rates loaded successfully")
        } catch {
            print("Failed to load rates: \(error)")
        }
    }

    func changeCurrency(to newCurrency: String) async {
        selectedCurrency = newCurrency
        await loadRatesIfNeeded()
    }

    func format(defultAppCurrency: Double) -> String {
        let rate = rates[selectedCurrency] ?? 1.0
        let finalPrice = defultAppCurrency * rate
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = selectedCurrency
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: finalPrice))
            ?? "\(finalPrice) \(selectedCurrency)"
    }

    // Add this helper to return the raw converted Double for APIs like Apple Pay
    func convert(amount: Double) -> Double {
        let rate = rates[selectedCurrency] ?? 1.0
        return amount * rate
    }
}
