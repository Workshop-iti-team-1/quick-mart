//
//  ProductToastView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductToastView: View {
    @ObservedObject var viewModel: ProductDetailsViewModel
    @Environment(AppRouter.self) var router
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.cyanPrimary)
                
                Text(AppStrings.ProductDetails.addedToCartMessage)
                    .appTextStyle(.label, color: Color.appWhite)
                
                Spacer()
                
                Button(action: {
                    viewModel.showToast = false
                    router.push(.cart)
                }) {
                    Text(AppStrings.ProductDetails.viewCart)
                        .appTextStyle(.label, color: Color.cyanPrimary)
                }
            }
            .padding()
            .background(Color.appBlack)
            .cornerRadius(12)
            .padding(.horizontal, 24)
            .padding(.top, 50)
            
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut, value: viewModel.showToast)
        .zIndex(2)
    }
}
