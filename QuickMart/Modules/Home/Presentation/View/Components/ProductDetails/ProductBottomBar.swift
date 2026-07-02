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
                        .appTextStyle(.button, color: Color.appBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)

                } else {
                    Text(AppStrings.ProductDetails.buyNow)
                        .appTextStyle(.button, color: Color.appBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(Color.appWhite)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBlack, lineWidth: 1))
            .disabled(viewModel.isAddingToCart)
            
            Button(action: {
                Task {
                    await viewModel.addToCart(buyNow: false)
                }
            }) {
                HStack {
                    Text(AppStrings.ProductDetails.addToCart)
                        .appTextStyle(.button, color: Color.appWhite)
                    Image(systemName: "cart")
                        .foregroundColor(Color.appWhite)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appBlack)
                .cornerRadius(16)
            }
            .disabled(viewModel.isAddingToCart)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.appWhite)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
    }
}
