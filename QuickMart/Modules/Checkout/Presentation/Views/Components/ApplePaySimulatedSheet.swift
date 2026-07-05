//
//  ApplePaySimulatedSheet.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import SwiftUI

struct ApplePaySimulatedSheet: View {

    let cart: Cart
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var isFaceIDAnimating: Bool = false
    @State private var isAuthenticating: Bool = false
    @State private var authComplete: Bool = false

    private enum Layout {
        static let cornerRadius: CGFloat    = 20
        static let faceIDSize: CGFloat      = 64
        static let buttonHeight: CGFloat    = 50
        static let buttonRadius: CGFloat    = 12
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag indicator
            Capsule()
                .fill(Color.grey100)
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 20)

            // Apple Pay header
            applePayHeader

            Divider()
                .padding(.vertical, 20)

            // Order summary
            orderSummaryRows

            Divider()
                .padding(.vertical, 20)

            // Total
            totalRow

            Spacer(minLength: 24)

            // Face ID section
            faceIDSection

            Spacer(minLength: 32)

            // Action buttons
            actionButtons
                .padding(.bottom, 32)
        }
        .padding(.horizontal, 24)
        .background(Color.appWhite)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(Layout.cornerRadius)
        .onAppear { startFaceIDPulse() }
    }

    // MARK: - Apple Pay Header

    private var applePayHeader: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: "applelogo")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.appBlack)
                Text("Pay")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.appBlack)
            }
            Text("QuickMart")
                .appTextStyle(.caption, color: .grayText)
        }
    }

    // MARK: - Order Summary Rows

    private var orderSummaryRows: some View {
        VStack(spacing: 12) {
            ForEach(cart.lines.prefix(3)) { line in
                HStack {
                    Text(line.merchandise.productTitle)
                        .appTextStyle(.body, color: .appBlack)
                        .lineLimit(1)
                    Spacer()
                    Text(
                        String(
                            format: "%@ %.2f",
                            cart.cost.currencyCode,
                            line.cost.totalAmount
                        )
                    )
                    .appTextStyle(.body, color: .appBlack)
                }
            }

            // "and X more" if cart has more than 3 items
            if cart.lines.count > 3 {
                HStack {
                    Text("and \(cart.lines.count - 3) more item(s)")
                        .appTextStyle(.caption, color: .grayText)
                    Spacer()
                }
            }
        }
    }

    // MARK: - Total Row

    private var totalRow: some View {
        HStack {
            Text("Total")
                .appTextStyle(.label, color: .appBlack)
            Spacer()
            Text(
                String(
                    format: "%@ %.2f",
                    cart.cost.currencyCode,
                    cart.cost.totalAmount
                )
            )
            .appTextStyle(.heading2, color: .appBlack)
        }
    }

    // MARK: - Face ID Section

    private var faceIDSection: some View {
        VStack(spacing: 12) {
            ZStack {
                // Pulse ring animation
                Circle()
                    .stroke(Color.cyanPrimary.opacity(0.2), lineWidth: 2)
                    .frame(width: Layout.faceIDSize + 20,
                           height: Layout.faceIDSize + 20)
                    .scaleEffect(isFaceIDAnimating ? 1.15 : 1.0)
                    .opacity(isFaceIDAnimating ? 0.0 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.2).repeatForever(autoreverses: false),
                        value: isFaceIDAnimating
                    )

                // Face ID icon
                Image(systemName: authComplete ? "checkmark.circle.fill" : "faceid")
                    .font(.system(size: Layout.faceIDSize * 0.6))
                    .foregroundColor(authComplete ? .cyanPrimary : .appBlack)
                    .frame(width: Layout.faceIDSize, height: Layout.faceIDSize)
                    .animation(.spring(duration: 0.3), value: authComplete)
            }

            Text(
                isAuthenticating
                    ? "Authenticating..."
                    : authComplete
                        ? "Authenticated"
                        : "Double-click to confirm"
            )
            .appTextStyle(.caption, color: .grayText)
            .animation(.easeInOut, value: isAuthenticating)
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Pay button
            Button {
                simulateFaceID()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "applelogo")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Pay with Face ID")
                        .appTextStyle(.button, color: .appWhite)
                }
                .frame(maxWidth: .infinity)
                .frame(height: Layout.buttonHeight)
                .background(Color.appBlack)
                .cornerRadius(Layout.buttonRadius)
            }
            .disabled(isAuthenticating || authComplete)

            // Cancel button
            Button(action: onCancel) {
                Text("Cancel")
                    .appTextStyle(.button, color: .appBlack)
                    .frame(maxWidth: .infinity)
                    .frame(height: Layout.buttonHeight)
                    .background(Color.grey50)
                    .cornerRadius(Layout.buttonRadius)
            }
            .disabled(isAuthenticating || authComplete)
        }
    }

    // MARK: - Face ID Simulation

    private func startFaceIDPulse() {
        isFaceIDAnimating = true
    }

    /// Simulates Face ID authentication:
    /// 1. Show "Authenticating..." for 1.5s
    /// 2. Show checkmark for 0.5s
    /// 3. Fire onConfirm
    private func simulateFaceID() {
        guard !isAuthenticating && !authComplete else { return }
        isAuthenticating = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isAuthenticating = false
            authComplete = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onConfirm()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    Color.black.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            ApplePaySimulatedSheet(
                cart: Cart(
                    id: "1",
                    checkoutUrl: "",
                    totalQuantity: 2,
                    cost: CartCost(
                        subtotalAmount: 47.40,
                        totalAmount: 47.40,
                        totalTaxAmount: nil,
                        currencyCode: "USD"
                    ),
                    lines: [],
                    discountCodes: []
                ),
                onConfirm: {},
                onCancel: {}
            )
        }
}
