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
    let discountCodes: [CartDiscountCode]
    let onCheckout: () -> Void
    
    @EnvironmentObject var currencyManager: CurrencyManagerService
    

    // MARK: - Computed

    private var discountAmount: Double {
        max(0, cost.subtotalAmount - cost.totalAmount)
    }

    private var hasActiveDiscount: Bool {
        discountAmount > 0 && discountCodes.contains { $0.applicable }
    }

    private var applicableCodes: [CartDiscountCode] {
        discountCodes.filter { $0.applicable }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(AppStrings.Cart.orderInfo)
                .appTextStyle(.heading2, color: .primary)

            // MARK: - Subtotal row

            costRow(
                title: AppStrings.Cart.subtotal,
                value: formatted(cost.subtotalAmount),
                titleColor: .grayText,
                valueColor: .grayText,
                strikethrough: hasActiveDiscount
            )

            // MARK: - Discount rows
            // One row per applicable code showing code + amount saved

            if hasActiveDiscount {
                VStack(spacing: 8) {
                    ForEach(applicableCodes, id: \.code) { discount in
                        HStack(spacing: 0) {
                            // Tag icon + code name
                            HStack(spacing: 6) {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.cyanPrimary)
                                Text(discount.code)
                                    .appTextStyle(.caption, color: .cyanPrimary)
                            }

                            Spacer(minLength: 8)

                            // Saving amount
                            Text("- \(formatted(discountAmount))")
                                .appTextStyle(.label, color: .cyanPrimary)
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.cyan50)
                )

                // "You save" callout
                HStack(spacing: 6) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.cyanPrimary)
                    Text("You save \(formatted(discountAmount))!")
                        .appTextStyle(.caption, color: .cyanPrimary)
                }
            }

            // MARK: - Not-applicable codes
            // Code was accepted by Shopify but conditions not met

            let notApplicable = discountCodes.filter { !$0.applicable }
            if !notApplicable.isEmpty {
                VStack(spacing: 6) {
                    ForEach(notApplicable, id: \.code) { discount in
                        VoucherRequirementView(
                            requirement: "\(discount.code): conditions not met.",
                            isMet: false
                        )
                    }
                }
            }

            // MARK: - Shipping

            costRow(
                title: AppStrings.Cart.shippingCost,
                value: "0.00 \(cost.currencyCode)",
                titleColor: .grayText,
                valueColor: .grayText,
                strikethrough: false
            )

            Divider()

            // MARK: - Total

            HStack(alignment: .top) {
                Text(AppStrings.Cart.total)
                    .appTextStyle(.heading2, color: .primary)

                Spacer()
                Text(currencyManager.format(defultAppCurrency: cost.totalAmount))
                    .appTextStyle(.heading2, color: .primary)

                VStack(alignment: .trailing, spacing: 4) {
                    // Original price struck through when discount active
                    if hasActiveDiscount {
                        Text(formatted(cost.subtotalAmount))
                            .appTextStyle(.caption, color: .grayText)
                            .strikethrough(true, color: .grayText)
                    }

                    // Final price — prominent
                    Text(formatted(cost.totalAmount))
                        .appTextStyle(.heading2, color: .primary)

                    // Total saved — shown below final price
                    if hasActiveDiscount {
                        Text("Saved \(formatted(discountAmount))")
                            .appTextStyle(.caption, color: .cyanPrimary)
                    }
                }
            }

            // MARK: - Checkout Button

            AppButton(
                title: "\(AppStrings.Cart.checkout) (\(itemCount))",
                action: onCheckout
            )
        }
        .padding(16)
    }

    // MARK: - Helpers

    private func formatted(_ amount: Double) -> String {
        String(format: "%.2f %@", amount, cost.currencyCode)
    }

    private func costRow(
        title: String,
        value: String,
        titleColor: Color,
        valueColor: Color,
        strikethrough: Bool
    ) -> some View {
        HStack {
            Text(title)
                .appTextStyle(.body, color: titleColor)
            Spacer()
            Text(value)
                .appTextStyle(.body, color: valueColor)
                .strikethrough(strikethrough, color: valueColor)
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
