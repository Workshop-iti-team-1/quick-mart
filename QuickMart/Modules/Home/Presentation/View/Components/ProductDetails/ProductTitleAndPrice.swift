//
//  ProductTitleAndPrice.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductTitleAndPrice: View {
    let product: ProductDetails
    @EnvironmentObject var currencyManager: CurrencyManagerService
    
    var body: some View {
        HStack(alignment: .top) {
            Text(product.title)
                .appTextStyle(.heading2, color: .primary)
                .lineLimit(2)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(currencyManager.format(defultAppCurrency: product.minPrice))
                    .appTextStyle(.heading2, color: .primary)
                
                if let originalPrice = product.compareAtPrice, originalPrice > product.minPrice {
                    HStack(spacing: 6) {
                        Text(currencyManager.format(defultAppCurrency: originalPrice))
                            .appTextStyle(.body, color: Color.grey150)
                            .strikethrough()
                        
                        let discount = Int(((originalPrice - product.minPrice) / originalPrice) * 100)
                        Text("-\(discount)%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
}
