//
//  ProductDescriptionView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductDescriptionView: View {
    let product: ProductDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                .appTextStyle(.body, color: Color.grey150)
                .lineLimit(4)
            
            Button(action: {}) {
                Text(AppStrings.ProductDetails.readMore)
                    .appTextStyle(.label, color: Color.cyanPrimary)
            }
        }
    }
}
