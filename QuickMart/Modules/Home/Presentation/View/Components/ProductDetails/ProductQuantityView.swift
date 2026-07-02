//
//  ProductQuantityView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductQuantityView: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppStrings.ProductDetails.quantity)
                .appTextStyle(.button, color: .primary)
            
            HStack(spacing: 16) {
                Button(action: { viewModel.decrementQuantity() }) {
                    Image(systemName: "minus")
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(Color.clear)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.grey100, lineWidth: 1))
                }
                
                Text("\(viewModel.quantity)")
                    .appTextStyle(.button, color: .primary)
                    .frame(width: 30)
                
                Button(action: { viewModel.incrementQuantity() }) {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(Color.clear)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.grey100, lineWidth: 1))
                }
            }
        }
    }
}
