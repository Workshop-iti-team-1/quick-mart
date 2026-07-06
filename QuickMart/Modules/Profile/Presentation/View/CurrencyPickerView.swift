//
//  CurrencyPickerView.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import SwiftUI

struct CurrencyPickerView: View {
    @StateObject var viewModel: CurrencyPickerViewModel
    @EnvironmentObject var currencyManager: CurrencyManagerService
    @Environment(\.dismiss) var dismiss

    init(viewModel: CurrencyPickerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                CurrencySearchBar(searchText: $viewModel.searchText)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.filteredCurrencies) { currency in
                            CurrencyRowView(
                                currency: currency,
                                isSelected: currencyManager.selectedCurrency == currency.code
                            ) {
                                Task {
                                    await currencyManager.changeCurrency(to: currency.code)
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationTitle(AppStrings.Currency.selectCurrency)
        .navigationBarTitleDisplayMode(.inline)
      
    }
}
