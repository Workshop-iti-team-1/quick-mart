//
//  ProductTitleAndPrice.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI
// ProductTitleAndPrice.swift

struct ProductTitleAndPrice: View {
    let product: ProductDetails
    @EnvironmentObject var currencyManager: CurrencyManagerService
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            Text(product.title)
                .appTextStyle(.heading3, color: .primary)
                .fixedSize(horizontal: false, vertical: true) // Allows vertical expansion
                .layoutPriority(1)
                        
            VStack(alignment: .trailing, spacing: 4) {
                Text(currencyManager.format(defultAppCurrency: product.minPrice))
                    .appTextStyle(.heading3, color: .primary)
                    .fixedSize(horizontal: true, vertical: false)
                
                if let originalPrice = product.compareAtPrice, originalPrice > product.minPrice {
                    HStack(spacing: 6) {
                        Text(currencyManager.format(defultAppCurrency: originalPrice))
                            .appTextStyle(.body, color: Color.grey150)
                            .strikethrough()
                            .fixedSize(horizontal: true, vertical: false)
                        
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
