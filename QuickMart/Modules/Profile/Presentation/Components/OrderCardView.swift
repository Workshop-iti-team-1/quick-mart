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
    let item: OrderLineItemEntity
    
    // Configuration flag to toggle between edit controls and read-only text.
    // Defaults to false since this model represents an already placed order.
    var isEditable: Bool = false

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

                    // Both status badges side by side
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

                // Date — always shown
                Text(formattedDate)
                    .appTextStyle(.caption, color: .grayText)
            }

            Divider()

            // MARK: - Product Row

            HStack(alignment: .top, spacing: 12) {

                // Product image
                ZStack {
                    Color.grey50

                    if let imageUrl = item.imageURL,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .empty:
                                ProgressView()
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
                       variantTitle != "Default Title" {
                        Text(variantTitle)
                            .appTextStyle(.caption, color: .grayText)
                    }

                    Text(
                        String(
                            format: "%.2f %@",
                            item.originalTotalPrice,
                            order.currencyCode
                        )
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
                    } else {
                        Text("Qty: \(item.quantity)")
                            .appTextStyle(.caption, color: .grayText)
                            .padding(.top, 4)
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
            // Apple Pay — fulfilled (Read-only mode)
            OrderCardView(
                order: OrderEntity(
                    id: "1",
                    orderNumber: 1001,
                    processedAt: Date(),
                    financialStatus: "PAID",
                    fulfillmentStatus: "FULFILLED",
                    currentTotalPrice: 47.40,
                    currentSubtotalPrice: 44.00,
                    currencyCode: "USD",
                    discountApplications: [],
                    lineItems: [],
                    shippingAddress: nil
                ),
                item: OrderLineItemEntity(
                    id: "li1",
                    title: "K800 Ultra Smart Watch",
                    quantity: 1,
                    originalTotalPrice: 32.00,
                    variantTitle: "Black",
                    imageURL: nil
                ),
                isEditable: false // Default behavior
            )

            // COD — pending payment, unfulfilled (Editable mode demo)
            OrderCardView(
                order: OrderEntity(
                    id: "2",
                    orderNumber: 1002,
                    processedAt: Date(),
                    financialStatus: "PENDING",
                    fulfillmentStatus: "UNFULFILLED",
                    currentTotalPrice: 25.25,
                    currentSubtotalPrice: 25.25,
                    currencyCode: "USD",
                    discountApplications: [],
                    lineItems: [],
                    shippingAddress: nil
                ),
                item: OrderLineItemEntity(
                    id: "li2",
                    title: "D20 Bluetooth Smart Headphones",
                    quantity: 2,
                    originalTotalPrice: 25.25,
                    variantTitle: nil,
                    imageURL: nil
                ),
                isEditable: true // Overridden behavior
            )
        }
        .padding(16)
    }
    .background(Color.backGround)
}
