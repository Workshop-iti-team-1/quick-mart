//
//  OrderSuccessView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import SwiftUI

struct OrderSuccessView: View {

    let order: PlacedOrder
    @Environment(AppRouter.self) private var router
    @EnvironmentObject var currencyManager: CurrencyManagerService

    private enum Layout {
        static let imageSize: CGFloat = 220
        static let horizontalPad: CGFloat = 24
        static let buttonHeight: CGFloat = 52
        static let buttonRadius: CGFloat = 12
        static let spacing: CGFloat = 16
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Success illustration
                Image("orderPlacedSuccessfully")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.imageSize, height: Layout.imageSize)
                    .padding(.bottom, 32)

                // Title
                Text("Your order has been\nplaced successfully")
                    .appTextStyle(.heading1, color: .appBlack)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)

                // Subtitle
                Text(
                    "Thank you for choosing us! Feel free to continue\nshopping and explore our wide range of products.\nHappy Shopping!"
                )
                .appTextStyle(.body, color: .grey150)
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)

                // Order details card
                orderDetailsCard
                    .padding(.horizontal, Layout.horizontalPad)
                    .padding(.bottom, 40)

                Spacer()

                // Continue Shopping button
                AppButton(
                    title: "Continue Shopping",
                    action: {
                        router.switchTab(to: .home)
                    }
                )
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.bottom, 32)
            }
        }
        // Hide back button — user should not go back to checkout after success
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    router.switchTab(to: .home)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.appBlack)
                }
            }
        }
    }

    // MARK: - Order Details Card

    private var orderDetailsCard: some View {
        VStack(spacing: 12) {
            detailRow(
                title: "Order Number",
                value: "#\(order.orderNumber)",
                valueColor: .cyanPrimary
            )

            Divider()

            detailRow(
                title: "Payment Method",
                value: order.paymentMethod.rawValue,
                valueColor: .appBlack
            )

            Divider()

            detailRow(
                title: "Total Paid",
                value: currencyManager.format(
                    defultAppCurrency: order.totalAmount),
                valueColor: .appBlack
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(
                    color: Color.appBlack.opacity(0.06),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }

    private func detailRow(
        title: String,
        value: String,
        valueColor: Color
    ) -> some View {
        HStack {
            Text(title)
                .appTextStyle(.body, color: .grey150)
            Spacer()
            Text(value)
                .appTextStyle(.label, color: valueColor)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        OrderSuccessView(
            order: PlacedOrder(
                id: "gid://shopify/Order/123456789",
                orderNumber: 1001,
                totalAmount: 47.40,
                currencyCode: "USD",
                paymentMethod: .applePay
            )
        )
        .environment(AppRouter())
    }
}
