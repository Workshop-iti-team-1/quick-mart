//
//  CartDeleteConfirmationSheet.swift
//  QuickMart
//
//  Created by siam on 4/07/2026.
//


import SwiftUI

struct CartDeleteConfirmationSheet: View {
    @Binding var isPresented: Bool
    var onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Capsule()
                .fill(Color.grey150.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 16)
            
            HStack {
                Text(AppStrings.Cart.deleteProductTitle)
                    .appTextStyle(.heading2, color: .primary)
                Spacer()
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                AppButton(
                    title: AppStrings.Cart.deleteProductButton,
                    style: .primary,
                    action: {
                        onDelete()
                        isPresented = false
                    }
                )
                
                AppButton(
                    title: AppStrings.General.cancel,
                    style: .secondary,
                    action: {
                        isPresented = false
                    }
                )
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color.backGround)
    }
}
