//
//  CheckoutOrderSummaryView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import SwiftUI

struct CheckoutOrderSummaryView: View {

    let cart: Cart
    @EnvironmentObject var currencyManager: CurrencyManagerService

    private enum Layout {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 12
        static let imageSize: CGFloat = 48
        static let shadowOpacity: Double = 0.06
        static let shadowRadius: CGFloat = 4
        static let shadowY: CGFloat = 2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            Text("Order Summary")
                .appTextStyle(.heading2, color: .appBlack)

            // Line items
            lineItemsCard

            // Cost breakdown
            costBreakdownCard
        }
    }

    // MARK: - Line Items

    private var lineItemsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(cart.lines.enumerated()), id: \.element.id) {
                index, line in
                lineRow(line: line)
                if index < cart.lines.count - 1 {
                    Divider()
                        .padding(
                            .leading, Layout.imageSize + 12 + Layout.padding)
                }
            }
        }
        .padding(Layout.padding)
        .background(cardBackground)
    }

    private func lineRow(line: CartLine) -> some View {
        HStack(spacing: 12) {
            // Product image
            AsyncImage(url: URL(string: line.merchandise.imageURL ?? "")) {
                phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.grey150)
                }
            }
            .frame(width: Layout.imageSize, height: Layout.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.grey50)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(line.merchandise.productTitle)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(1)

                if line.merchandise.title != "Default Title" {
                    Text(line.merchandise.title)
                        .appTextStyle(.caption, color: .grey150)
                }

                Text("Qty: \(line.quantity)")
                    .appTextStyle(.caption, color: .grey150)
            }

            Spacer(minLength: 0)

            Text(
                currencyManager.format(defultAppCurrency: line.cost.totalAmount)
            )
            .appTextStyle(.label, color: .appBlack)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Cost Breakdown

    private var costBreakdownCard: some View {
        VStack(spacing: 12) {
            // Subtotal
            costRow(
                title: "Subtotal",
                value: currencyManager.format(
                    defultAppCurrency: cart.cost.subtotalAmount),
                titleStyle: .body,
                valueStyle: .body
            )

            // Applied discount codes
            ForEach(
                cart.discountCodes.filter { $0.applicable },
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
                    Text("Applied")
                        .appTextStyle(.caption, color: .cyanPrimary)
                }
            }

            // Tax — only shown when non-zero
            if let tax = cart.cost.totalTaxAmount, tax > 0 {
                costRow(
                    title: "Tax",
                    value: currencyManager.format(
                        defultAppCurrency: tax),
                    titleStyle: .body,
                    valueStyle: .body
                )
            }

            Divider()

            // Total
            costRow(
                title: "Total",
                value: currencyManager.format(
                    defultAppCurrency: cart.cost.totalAmount),
                titleStyle: .label,
                valueStyle: .heading2
            )
        }
        .padding(Layout.padding)
        .background(cardBackground)
    }

    private func costRow(
        title: String,
        value: String,
        titleStyle: AppTextStyle.TextStyle,
        valueStyle: AppTextStyle.TextStyle
    ) -> some View {
        HStack {
            Text(title)
                .appTextStyle(titleStyle, color: .grey150)
            Spacer()
            Text(value)
                .appTextStyle(valueStyle, color: .appBlack)
        }
    }

    // MARK: - Shared Background

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .fill(Color.cardBackground)
            .shadow(
                color: Color.appBlack.opacity(Layout.shadowOpacity),
                radius: Layout.shadowRadius,
                x: 0,
                y: Layout.shadowY
            )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        CheckoutOrderSummaryView(
            cart: Cart(
                id: "1",
                checkoutUrl: "",
                totalQuantity: 2,
                cost: CartCost(
                    subtotalAmount: 47.40,
                    totalAmount: 47.40,
                    totalTaxAmount: 3.50,
                    currencyCode: "USD"
                ),
                lines: [
                    CartLine(
                        id: "l1",
                        quantity: 1,
                        cost: CartLineCost(
                            totalAmount: 32.00,
                            amountPerQuantity: 32.00,
                            currencyCode: "USD"
                        ),
                        merchandise: ProductVariant(
                            id: "v1",
                            title: "Black / Large",
                            price: 32.00,
                            compareAtPrice: nil,
                            availableForSale: true,
                            quantityAvailable: 10,
                            imageURL: nil,
                            productTitle: "K800 Ultra Smart Watch",
                            productVendor: "Adidas"
                        )
                    )
                ],
                discountCodes: [
                    CartDiscountCode(code: "SAVE10", applicable: true)
                ]
            )
        )
        .padding(16)
    }
    .background(Color.backGround)
}
