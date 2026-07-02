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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.Cart.orderInfo)
                .appTextStyle(.heading2, color: .primary)
            
            HStack {
                Text(AppStrings.Cart.subtotal)
                    .appTextStyle(.body, color: .gray)
                Spacer()
                Text("\(cost.subtotalAmount, specifier: "%.2f") \(cost.currencyCode)")
                    .appTextStyle(.body, color: .gray)
            }
            
            HStack {
                Text(AppStrings.Cart.shippingCost)
                    .appTextStyle(.body, color: .gray)
                Spacer()
                // Mocking $0.00 since Shopify often calculates shipping at checkout
                Text("0.00 \(cost.currencyCode)")
                    .appTextStyle(.body, color: .gray)
            }
            
            HStack {
                Text(AppStrings.Cart.total)
                    .appTextStyle(.heading2, color: .primary)
                Spacer()
                Text("\(cost.totalAmount, specifier: "%.2f") \(cost.currencyCode)")
                    .appTextStyle(.heading2, color: .primary)
            }
            
            Button(action: onCheckout) {
                Text("\(AppStrings.Cart.checkout) (\(itemCount))")
                    .appTextStyle(.button, color: .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .background(Color.cyanPrimary)
            .cornerRadius(12)
            .padding(.top, 8)
        }
        .padding(16)
    }
}

// Helper for corner radius
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
