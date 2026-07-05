//
//  OrderSummaryView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//
// Features/Cart/Presentation/Views/OrderSummaryView.swift
// Features/Cart/Presentation/Views/OrderSummaryView.swift

import SwiftUI

struct OrderSummaryView: View {
    let cost: CartCost
    let itemCount: Int
    let discountCodes: [CartDiscountCode]
    let onCheckout: () -> Void

    private var discountAmount: Double {
        cost.subtotalAmount - cost.totalAmount
    }

    private var hasActiveDiscount: Bool {
        discountAmount > 0 && discountCodes.contains { $0.applicable }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(AppStrings.Cart.orderInfo)
                .appTextStyle(.heading2, color: .primary)

            // Subtotal
            costRow(
                title: AppStrings.Cart.subtotal,
                value: String(
                    format: "%.2f %@",
                    cost.subtotalAmount,
                    cost.currencyCode
                ),
                color: .grayText
            )

            // Discount row — only shown when voucher actually reduces price
            if hasActiveDiscount {
                VStack(spacing: 8) {
                    ForEach(
                        discountCodes.filter { $0.applicable },
                        id: \.code
                    ) { discount in
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.cyanPrimary)
                                Text(discount.code)
                                    .appTextStyle(.caption, color: .cyanPrimary)
                            }
                            Spacer()
                            Text(
                                String(
                                    format: "-%.2f %@",
                                    discountAmount,
                                    cost.currencyCode
                                )
                            )
                            .appTextStyle(.label, color: .cyanPrimary)
                        }
                    }
                }
                .padding(10)
                .background(Color.cyan50)
                .cornerRadius(8)
            }

            // Shipping
            costRow(
                title: AppStrings.Cart.shippingCost,
                value: "0.00 \(cost.currencyCode)",
                color: .grayText
            )

            Divider()

            // Total
            HStack {
                Text(AppStrings.Cart.total)
                    .appTextStyle(.heading2, color: .primary)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    // Strike-through original price when discount is active
                    if hasActiveDiscount {
                        Text(
                            String(
                                format: "%.2f %@",
                                cost.subtotalAmount,
                                cost.currencyCode
                            )
                        )
                        .appTextStyle(.caption, color: .grayText)
                        .strikethrough(true, color: .grayText)
                    }
                    Text(
                        String(
                            format: "%.2f %@",
                            cost.totalAmount,
                            cost.currencyCode
                        )
                    )
                    .appTextStyle(.heading2, color: .primary)
                }
            }

            AppButton(
                title: "\(AppStrings.Cart.checkout) (\(itemCount))",
                action: onCheckout
            )
        }
        .padding(16)
    }

    // MARK: - Helper

    private func costRow(
        title: String,
        value: String,
        color: Color
    ) -> some View {
        HStack {
            Text(title)
                .appTextStyle(.body, color: color)
            Spacer()
            Text(value)
                .appTextStyle(.body, color: color)
        }
    }
}

// MARK: - Corner Radius Helpers

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
