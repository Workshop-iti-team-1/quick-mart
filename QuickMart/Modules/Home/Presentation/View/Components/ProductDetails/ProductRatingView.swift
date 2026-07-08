//
//  ProductRatingView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductRatingView: View {
    let product: ProductDetails
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { i in
                Image(systemName: i < Int(product.rating) ? "star.fill" : "star")
                    .foregroundColor(Color.appYellow)
                    .font(.caption)
            }
            Text("\(String(format: "%.1f", product.rating)) (\(product.reviewsCount) reviews)")
                .appTextStyle(.label, color: Color.appBlack)
        }
    }
}
