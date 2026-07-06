//
//  OrderDetailView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//
// Features/Profile/Presentation/Views/OrderDetailView.swift

import SwiftUI

struct OrderDetailView: View {

    let order: OrderEntity
    @EnvironmentObject var currencyManager: CurrencyManagerService

    private enum Layout {
        static let horizontalPad: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let cornerRadius: CGFloat = 12
        static let shadowOpacity: Double = 0.06
        static let shadowRadius: CGFloat = 4
        static let shadowY: CGFloat = 2
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy · h:mm a"
        return formatter.string(from: order.processedAt)
    }

    private var paymentStatus: PaymentStatus {
        PaymentStatus(rawValue: order.financialStatus)
    }

    private var fulfillmentStatus: FulfillmentStatus {
        FulfillmentStatus(rawValue: order.fulfillmentStatus)
    }

    private var discountAmount: Double {
        max(0, order.currentSubtotalPrice - order.currentTotalPrice)
    }

    private var hasDiscount: Bool {
        !order.discountApplications.isEmpty && discountAmount > 0
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {

                // Section 1 — Order Header
                orderHeaderSection

                // Section 2 — Status
                statusSection

                // Section 3 — Items
                itemsSection

                // Section 4 — Shipping Address
                if let address = order.shippingAddress {
                    shippingAddressSection(address: address)
                }

                // Section 5 — Discounts
                if !order.discountApplications.isEmpty {
                    discountsSection
                }

                // Section 6 — Pricing Breakdown
                pricingSection
            }
            .padding(.horizontal, Layout.horizontalPad)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationTitle("Order #\(order.orderNumber)")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Section 1: Order Header

    private var orderHeaderSection: some View {
        card {
            VStack(alignment: .leading, spacing: 10) {
                detailRow(
                    icon: "number",
                    title: "Order Number",
                    value: "#\(order.orderNumber)"
                )
                Divider()
                detailRow(
                    icon: "calendar",
                    title: "Order Date",
                    value: formattedDate
                )
            }
        }
    }

    // MARK: - Section 2: Status

    private var statusSection: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                Text("Status")
                    .appTextStyle(.label, color: .appBlack)

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Payment")
                            .appTextStyle(.caption, color: .grayText)
                        OrderStatusBadge(type: .payment(paymentStatus))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 6) {
                        Text("Fulfillment")
                            .appTextStyle(.caption, color: .grayText)
                        OrderStatusBadge(type: .fulfillment(fulfillmentStatus))
                    }
                }

                // COD note
                if paymentStatus == .pending {
                    HStack(spacing: 6) {
                        Image(systemName: "banknote")
                            .font(.system(size: 11))
                            .foregroundColor(.appOrange)
                        Text("Payment will be collected on delivery.")
                            .appTextStyle(.caption, color: .appOrange)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.appOrange.opacity(0.08))
                    .cornerRadius(6)
                }
            }
        }
    }

    // MARK: - Section 3: Items

    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Items Ordered (\(order.lineItems.count))")

            card {
                VStack(spacing: 0) {
                    ForEach(
                        Array(order.lineItems.enumerated()), id: \.element.id
                    ) { index, item in
                        itemRow(item: item)
                        if index < order.lineItems.count - 1 {
                            Divider()
                                .padding(.leading, 68)
                        }
                    }
                }
            }
        }
    }

    private func itemRow(item: OrderLineItemEntity) -> some View {
        HStack(spacing: 12) {
            // Product image
            ZStack {
                Color.grey50
                if let urlString = item.imageURL,
                    let url = URL(string: urlString)
                {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
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
            .frame(width: 56, height: 56)
            .cornerRadius(8)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)

                if let variant = item.variantTitle,
                    !variant.isEmpty,
                    variant != "Default Title"
                {
                    Text(variant)
                        .appTextStyle(.caption, color: .grayText)
                }

                Text("Qty: \(item.quantity)")
                    .appTextStyle(.caption, color: .grayText)
            }

            Spacer(minLength: 0)

            // Price
            Text(
                currencyManager.format(
                    defultAppCurrency: item.originalTotalPrice)
            )
            .appTextStyle(.label, color: .appBlack)
        }
        .padding(.vertical, 12)
    }

    // MARK: - Section 4: Shipping Address

    private func shippingAddressSection(
        address: OrderShippingAddressEntity
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Shipping Address")
            card {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.cyan50)
                            .frame(width: 36, height: 36)
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.cyanPrimary)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        let name = [address.firstName, address.lastName]
                            .compactMap { $0 }
                            .joined(separator: " ")
                        if !name.isEmpty {
                            Text(name)
                                .appTextStyle(.label, color: .appBlack)
                        }

                        let addressLine = [
                            address.address1,
                            address.city,
                            address.country,
                        ]
                        .compactMap { $0 }
                        .filter { !$0.isEmpty }
                        .joined(separator: ", ")

                        if !addressLine.isEmpty {
                            Text(addressLine)
                                .appTextStyle(.caption, color: .grayText)
                                .lineLimit(2)
                        }

                        if let phone = address.phone, !phone.isEmpty {
                            Text(phone)
                                .appTextStyle(.caption, color: .grayText)
                        }
                    }

                    Spacer(minLength: 0)
                }
            }
        }
    }

    // MARK: - Section 5: Discounts

    private var discountsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Applied Discounts")
            card {
                VStack(spacing: 10) {
                    ForEach(
                        Array(order.discountApplications.enumerated()),
                        id: \.offset
                    ) { _, discount in
                        HStack {
                            HStack(spacing: 6) {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.cyanPrimary)
                                Text(discount.code)
                                    .appTextStyle(.label, color: .cyanPrimary)
                            }

                            Spacer()

                            // Show percentage or fixed amount
                            if let pct = discount.percentage, pct > 0 {
                                Text(
                                    String(format: "%.0f%% off", pct)
                                )
                                .appTextStyle(.label, color: .cyanPrimary)
                            } else if let amt = discount.amount, amt > 0 {
                                Text("- \(formatted(amt))")
                                    .appTextStyle(.label, color: .cyanPrimary)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Section 6: Pricing Breakdown

    private var pricingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Price Summary")
            card {
                VStack(spacing: 12) {
                    // Subtotal
                    pricingRow(
                        title: "Subtotal",
                        value: currencyManager.format(
                            defultAppCurrency: order.currentSubtotalPrice),
                        titleColor: .grayText,
                        valueColor: .grayText,
                        strikethrough: hasDiscount
                    )

                    // Discount saved
                    if hasDiscount {
                        HStack {
                            Text("Discount")
                                .appTextStyle(.body, color: .cyanPrimary)
                            Spacer()
                            Text(
                                "- \(currencyManager.format(defultAppCurrency: discountAmount))"
                            )
                            .appTextStyle(.label, color: .cyanPrimary)
                        }
                    }

                    // Shipping
                    HStack {
                        Text("Shipping")
                            .appTextStyle(.body, color: .grayText)
                        Spacer()
                        Text("Free")
                            .appTextStyle(.body, color: .cyanPrimary)
                    }

                    Divider()

                    // Total
                    HStack(alignment: .top) {
                        Text("Total")
                            .appTextStyle(.heading2, color: .appBlack)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            if hasDiscount {
                                Text(
                                    currencyManager.format(
                                        defultAppCurrency: order
                                            .currentSubtotalPrice)
                                )
                                .appTextStyle(.caption, color: .grayText)
                                .strikethrough(true, color: .grayText)
                            }
                            Text(
                                currencyManager.format(
                                    defultAppCurrency: order.currentTotalPrice)
                            )
                            .appTextStyle(.heading2, color: .appBlack)
                            if hasDiscount {
                                Text(
                                    "Saved \(currencyManager.format(defultAppCurrency: discountAmount))"
                                )
                                .appTextStyle(.caption, color: .cyanPrimary)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Shared Components

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .appTextStyle(.heading2, color: .appBlack)
    }

    private func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.cyanPrimary)
                .frame(width: 20)

            Text(title)
                .appTextStyle(.body, color: .grayText)

            Spacer()

            Text(value)
                .appTextStyle(.label, color: .appBlack)
        }
    }

    private func pricingRow(
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

    private func formatted(_ amount: Double) -> String {
        String(format: "%.2f %@", amount, order.currencyCode)
    }

    private func card<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(Layout.horizontalPad)
            .background(
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color.appWhite)
                    .shadow(
                        color: Color.appBlack.opacity(Layout.shadowOpacity),
                        radius: Layout.shadowRadius,
                        x: 0,
                        y: Layout.shadowY
                    )
            )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OrderDetailView(
            order: OrderEntity(
                id: "gid://shopify/Order/1",
                orderNumber: 1001,
                processedAt: Date(),
                financialStatus: "PAID",
                fulfillmentStatus: "UNFULFILLED",
                currentTotalPrice: 42.75,
                currentSubtotalPrice: 47.50,
                currencyCode: "USD",
                discountApplications: [
                    DiscountApplicationEntity(
                        code: "SAVE10",
                        percentage: nil,
                        amount: 4.75
                    )
                ],
                lineItems: [
                    OrderLineItemEntity(
                        id: "v1",
                        title: "K800 Ultra Smart Watch",
                        quantity: 1,
                        originalTotalPrice: 32.00,
                        variantTitle: "Black",
                        imageURL: nil
                    ),
                    OrderLineItemEntity(
                        id: "v2",
                        title: "Loop Silicone Headphones",
                        quantity: 2,
                        originalTotalPrice: 15.50,
                        variantTitle: nil,
                        imageURL: nil
                    ),
                ],
                shippingAddress: OrderShippingAddressEntity(
                    firstName: "John",
                    lastName: "Doe",
                    address1: "123 Main St",
                    city: "New York",
                    country: "United States",
                    phone: "+1 555 000 1234"
                )
            )
        )
        .environment(AppRouter())
    }
}
