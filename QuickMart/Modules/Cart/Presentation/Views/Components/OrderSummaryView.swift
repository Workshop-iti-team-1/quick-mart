//
//  OrderSummaryView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct OrderSummaryView: View {
    let cost: CartCost
    let itemCount: Int
    let onCheckout: () -> Void
    
    @EnvironmentObject var currencyManager: CurrencyManagerService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.Cart.orderInfo)
                .appTextStyle(.heading2, color: .primary)
            
            HStack {
                Text(AppStrings.Cart.subtotal)
                    .appTextStyle(.body, color: .gray)
                Spacer()
                Text(currencyManager.format(defultAppCurrency: cost.subtotalAmount))
                    .appTextStyle(.body, color: .gray)
            }
            
            if cost.subtotalAmount > cost.totalAmount {
                let discountAmount = cost.subtotalAmount - cost.totalAmount
                let discountPercentage = Int((discountAmount / cost.subtotalAmount) * 100)
                
                HStack {
                    Text("\(AppStrings.Cart.discount) (\(discountPercentage)%)")
                        .appTextStyle(.body, color: .red)
                    Spacer()
                    Text("-" + currencyManager.format(defultAppCurrency: discountAmount))
                        .appTextStyle(.body, color: .red)
                }
            }
            
            HStack {
                Text(AppStrings.Cart.shippingCost)
                    .appTextStyle(.body, color: .gray)
                Spacer()
     
                Text(currencyManager.format(defultAppCurrency: 0.0))
                    .appTextStyle(.body, color: .gray)
            }
            
            HStack {
                Text(AppStrings.Cart.total)
                    .appTextStyle(.heading2, color: .primary)
                Spacer()
                Text(currencyManager.format(defultAppCurrency: cost.totalAmount))
                    .appTextStyle(.heading2, color: .primary)
            }
            
            AppButton(title: "\(AppStrings.Cart.checkout) (\(itemCount))", action:onCheckout)
        
        }
        .padding(16)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
