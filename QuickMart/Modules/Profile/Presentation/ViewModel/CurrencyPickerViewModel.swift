//
//  CurrencyPickerViewModel.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import Foundation

@MainActor
class CurrencyPickerViewModel: ObservableObject {
    @Published var searchText : String = ""
    
    var filteredCurrencies: [CurrencyItem]{
        if searchText.isEmpty {
            return AppConstants.allCurrencies
        } else{
            return AppConstants.allCurrencies.filter{
                $0.code.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
