//
//  CheckoutView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//
// Features/Checkout/Presentation/Views/CheckoutView.swift

import SwiftUI

struct CheckoutView: View {

    @StateObject private var viewModel: CheckoutViewModel
    @Environment(AppRouter.self) private var router
    @State private var isAddressPickerPresented: Bool = false
    @EnvironmentObject var currencyManager: CurrencyManagerService

    private enum Layout {
        static let horizontalPad: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let buttonHeight: CGFloat = 52
        static let buttonRadius: CGFloat = 12
        static let bottomPad: CGFloat = 32
    }

    // MARK: - Init

    init(viewModel: CheckoutViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backGround.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Layout.sectionSpacing) {

                    // Section 1 — Shipping Address
                    CheckoutAddressCard(
                        selectedAddress: viewModel.selectedAddress,
                        onChangeTap: {
                            isAddressPickerPresented = true
                        }
                    )

                    // Section 2 — Payment Method
                    PaymentMethodSectionView(
                        selectedMethod: $viewModel.selectedPaymentMethod
                    )

                    // Section 3 — Order Summary
                    CheckoutOrderSummaryView(cart: viewModel.cart)
                }
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.top, 16)
                .padding(.bottom, Layout.buttonHeight + Layout.bottomPad + 32)
            }

            payButton
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.bottom, Layout.bottomPad)
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadAddresses()
        }
        // Independent address picker sheet
        // Does NOT push shippingAddresses or touch the user's default address
        .sheet(isPresented: $isAddressPickerPresented) {
            CheckoutAddressPickerView(
                addresses: viewModel.addresses,
                selectedAddress: viewModel.selectedAddress,
                onSelect: { address in
                    viewModel.selectedAddress = address
                },
                onAddNew: {
                    // Push to existing address form flow
                    // AddressEventsBus will notify CheckoutViewModel when saved
                    router.push(.shippingAddresses)
                }
            )
        }
        // Navigate to success when order is placed
        .onChange(of: viewModel.placedOrder) { _, order in
            guard let order else { return }
            router.push(.orderSuccess(order))
        }
        // Error alert
        .alert("Order Failed", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Something went wrong.")
        }
        // Loading overlay
        .overlay {
            if viewModel.isPlacingOrder {
                ZStack {
                    Color.black.opacity(0.35).ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(.appWhite)
                            .scaleEffect(1.4)
                        Text("Placing your order...")
                            .appTextStyle(.body, color: .appWhite)
                    }
                }
            }
        }
    }

    // MARK: - Pay Button

    private var payButton: some View {
        Button {
            // Get the raw converted amount and currency code
            let finalAmount = currencyManager.convert(
                amount: viewModel.cart.cost.totalAmount)
            let currencyCode = currencyManager.selectedCurrency

            // Pass them to the ViewModel
            viewModel.initiatePayment(
                amount: finalAmount, currencyCode: currencyCode)
        } label: {
            HStack(spacing: 8) {
                if viewModel.isPlacingOrder {
                    ProgressView()
                        .tint(.appWhite)
                } else {
                    Image(systemName: viewModel.selectedPaymentMethod.iconName)
                        .font(.system(size: 16, weight: .semibold))
                    Text(payButtonTitle)
                        .appTextStyle(.button, color: .appWhite)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Layout.buttonHeight)
            .background(
                viewModel.selectedAddress == nil
                    ? Color.grey150
                    : Color.appBlack
            )
            .cornerRadius(Layout.buttonRadius)
        }
        .disabled(viewModel.selectedAddress == nil || viewModel.isPlacingOrder)
        .animation(
            .easeInOut(duration: 0.2), value: viewModel.selectedPaymentMethod)
    }
    private var payButtonTitle: String {
        switch viewModel.selectedPaymentMethod {
        case .applePay:
            return "Pay with Apple Pay"
        case .cashOnDelivery:
            let total = currencyManager.format(
                defultAppCurrency: viewModel.cart.cost.totalAmount)
            return "Place Order · \(total)"
        }
    }
}
