//
//  OrderCardView.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//
// Features/Profile/Presentation/Components/OrderCardView.swift

import SwiftUI

struct OrderCardView: View {

    let order: OrderEntity
    @EnvironmentObject var currencyManager: CurrencyManagerService

    var isEditable: Bool = false

    private var primaryItem: OrderLineItemEntity? {
        order.lineItems.first
    }

    private var totalItemCount: Int {
        order.lineItems.reduce(0) { $0 + $1.quantity }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter.string(from: order.processedAt)
    }

    private var paymentStatus: PaymentStatus {
        PaymentStatus(rawValue: order.financialStatus)
    }

    private var fulfillmentStatus: FulfillmentStatus {
        FulfillmentStatus(rawValue: order.fulfillmentStatus)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Header: Status Badges + Date

            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 6) {
                    // Order number
                    Text("Order #\(order.orderNumber)")
                        .appTextStyle(.label, color: .appBlack)

                    HStack(spacing: 6) {
                        OrderStatusBadge(
                            type: .payment(paymentStatus)
                        )
                        OrderStatusBadge(
                            type: .fulfillment(fulfillmentStatus)
                        )
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(formattedDate)
                        .appTextStyle(.caption, color: .grayText)

                    Text("\(totalItemCount) \(totalItemCount == 1 ? "Item" : "Items")")
                        .appTextStyle(.caption, color: .grayText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.grey100)
                        .cornerRadius(6)
                }
            }

            Divider()

            // MARK: - Product Row (preview of first item in the order)

            if let item = primaryItem {
                HStack(alignment: .top, spacing: 12) {

                    // Product image
                    ZStack {
                        Color.grey50

                        if let imageUrl = item.imageURL,
                            let url = URL(string: imageUrl)
                        {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .empty:
                                    // Asset Loading Shimmer
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.shimmerBase)
                                        .frame(width: 80, height: 80)
                                        .shimmer()
                                default:
                                    Image(systemName: "photo")
                                        .foregroundColor(.grey150)
                                }
                            }
                        } else {
                            Image(systemName: "photo")
                                .foregroundColor(.grey150)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)

                    // Product info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .appTextStyle(.body, color: .appBlack)
                            .lineLimit(2)

                        if let variantTitle = item.variantTitle,
                            variantTitle != "Default Title"
                        {
                            Text(variantTitle)
                                .appTextStyle(.caption, color: .grayText)
                        }

                        Text(
                            currencyManager.format(
                                defultAppCurrency: order.currentTotalPrice)
                        )
                        .appTextStyle(.label, color: .appBlack)

                        // MARK: Quantity display (Dynamic)
                        if isEditable {
                            HStack(spacing: 16) {
                                Text("-")
                                    .appTextStyle(.body, color: .grayText)
                                Text("\(item.quantity)")
                                    .appTextStyle(.body, color: .appBlack)
                                Text("+")
                                    .appTextStyle(.body, color: .grayText)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.grey50)
                            .cornerRadius(8)
                            .padding(.top, 4)
                        } else if order.lineItems.count > 1 {
                            // Multiple distinct products — point to OrderDetails
                            Text("+ \(order.lineItems.count - 1) more product\(order.lineItems.count - 1 == 1 ? "" : "s")")
                                .appTextStyle(.caption, color: .cyanPrimary)
                                .padding(.top, 4)
                        } else {
                            Text("Qty: \(item.quantity)")
                                .appTextStyle(.caption, color: .grayText)
                                .padding(.top, 4)
                        }
                    }
                }
            }

            // MARK: - COD note
            // Shown only for pending COD orders to set user expectation

            if paymentStatus == .pending {
                HStack(spacing: 6) {
                    Image(systemName: "banknote")
                        .font(.system(size: 11))
                        .foregroundColor(.appOrange)
                    Text("Payment collected on delivery")
                        .appTextStyle(.caption, color: .appOrange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.appOrange.opacity(0.08))
                .cornerRadius(6)
            }
        }
        .padding(16)
        .background(Color.backGround)
        .cornerRadius(16)
        .shadow(
            color: Color.appBlack.opacity(0.05),
            radius: 5,
            x: 0,
            y: 2
        )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            OrderCardView(
                order: OrderEntity(
                    id: "1",
                    orderNumber: 1001,
                    processedAt: Date(),
                    financialStatus: "PAID",
                    fulfillmentStatus: "FULFILLED",
                    currentTotalPrice: 32.00,
                    currentSubtotalPrice: 32.00,
                    currencyCode: "USD",
                    discountApplications: [],
                    lineItems: [
                        OrderLineItemEntity(
                            id: "li1",
                            title: "K800 Ultra Smart Watch",
                            quantity: 1,
                            originalTotalPrice: 32.00,
                            variantTitle: "Black",
                            imageURL: nil
                        )
                    ],
                    shippingAddress: nil
                ),
                isEditable: false
            )

            OrderCardView(
                order: OrderEntity(
                    id: "2",
                    orderNumber: 1002,
                    processedAt: Date(),
                    financialStatus: "PENDING",
                    fulfillmentStatus: "UNFULFILLED",
                    currentTotalPrice: 75.50,
                    currentSubtotalPrice: 75.50,
                    currencyCode: "USD",
                    discountApplications: [],
                    lineItems: [
                        OrderLineItemEntity(
                            id: "li2",
                            title: "D20 Bluetooth Smart Headphones",
                            quantity: 2,
                            originalTotalPrice: 50.50,
                            variantTitle: nil,
                            imageURL: nil
                        ),
                        OrderLineItemEntity(
                            id: "li3",
                            title: "Phone Case",
                            quantity: 1,
                            originalTotalPrice: 25.00,
                            variantTitle: "Clear",
                            imageURL: nil
                        )
                    ],
                    shippingAddress: nil
                ),
                isEditable: false
            )
        }
        .padding(16)
    }
    .background(Color.backGround)
}
