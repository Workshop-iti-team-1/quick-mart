//
//  GuestCartView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct GuestCartView: View {
    var onLoginTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("gustmodecart") // Assuming the user added this
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            
            Text(AppStrings.Cart.guestCartTitle)
                .appTextStyle(.heading2, color: .primary)
            
            Text(AppStrings.Cart.guestCartMessage)
                .appTextStyle(.body, color: .grey150)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            AppButton(title: AppStrings.Cart.login, verticalPadding: 16) {
                onLoginTapped()
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
    }
}
