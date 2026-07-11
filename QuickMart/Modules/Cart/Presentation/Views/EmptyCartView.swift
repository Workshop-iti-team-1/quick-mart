//
//  EmptyCartView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct EmptyCartView: View {
    var onExploreTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("emptycart") // Assuming the user added this
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Text(AppStrings.Cart.emptyCartTitle)
                .appTextStyle(.heading2, color: .primary)
            
            Text(AppStrings.Cart.emptyCartMessage)
                .appTextStyle(.body, color: .grey150)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            AppButton(title: AppStrings.Cart.exploreBrands, verticalPadding: 16) {
                onExploreTapped()
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
    }
}
