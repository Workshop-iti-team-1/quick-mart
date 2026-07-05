//
//  searchBar.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

import SwiftUI

struct CurrencySearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.grey150)

            TextField(AppStrings.Currency.searchCurrency, text: $searchText)
                .appTextStyle(.body, color: .primary)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.grey150)
                }
            }
        }
        .padding(16)
        .background(Color.grey100.opacity(0.3))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.grey150.opacity(0.3), lineWidth: 0.5)
        )
    }
}
