//
//  ProductTitleAndPrice.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductTitleAndPrice: View {
    let product: ProductDetails
    
    var body: some View {
        HStack(alignment: .top) {
            Text(product.title)
                .appTextStyle(.heading2, color: .primary)
                .lineLimit(2)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", product.minPrice))")
                    .appTextStyle(.heading2, color: .primary)
                
                if let originalPrice = product.compareAtPrice {
                    Text("$\(String(format: "%.2f", originalPrice))")
                        .appTextStyle(.body, color: Color.grey150)
                        .strikethrough()
                }
            }
        }
    }
}
