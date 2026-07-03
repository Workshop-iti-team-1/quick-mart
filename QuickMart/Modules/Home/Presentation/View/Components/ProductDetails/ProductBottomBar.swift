//
//  ProductBottomBar.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductBottomBar: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                Task {
                    await viewModel.addToCart(buyNow: true)
                }
            }) {
                if viewModel.isAddingToCart {
                    Text(AppStrings.ProductDetails.buyNow)
                        .appTextStyle(.button, color: .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)

                } else {
                    Text(AppStrings.ProductDetails.buyNow)
                        .appTextStyle(.button, color: .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(Color.clear)
            .cornerRadius(16)
            .disabled(viewModel.isAddingToCart)
            
            AppButton(
                title: AppStrings.ProductDetails.addToCart,
                icon: "cart",
                action: {
                    Task {
                        await viewModel.addToCart(buyNow: false)
                    }
                }
            )
            .disabled(viewModel.isAddingToCart)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.backGround)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
    }
}
