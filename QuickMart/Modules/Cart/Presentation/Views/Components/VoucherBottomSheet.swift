//
//  VoucherBottomSheet.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct VoucherBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var voucherCode: String = ""
    var onApply: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(AppStrings.Cart.voucherCode)
                .appTextStyle(.heading2, color: .primary)
                .padding(.top, 16)
            
            CustomTextField(
                title: "",
                placeholder: AppStrings.Cart.enterVoucherCode,
                text: $voucherCode
            )
            
            AppButton(title: AppStrings.Cart.apply, verticalPadding: 16,) {
                onApply(voucherCode)
                isPresented = false
            }
            .disabled(voucherCode.isEmpty)
            
            Spacer()
        }
        .padding(24)
        .background(Color.backGround.ignoresSafeArea())
    }
}
