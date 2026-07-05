//
//  CheckoutView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import SwiftUI

struct CheckoutView: View {

    @StateObject private var viewModel: CheckoutViewModel
    @Environment(AppRouter.self) private var router

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

            // Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Layout.sectionSpacing) {

                    // Section 1 — Shipping Address
                    CheckoutAddressCard(
                        selectedAddress: viewModel.selectedAddress,
                        onChangeTap: {
                            router.push(.shippingAddresses)
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
                // Extra bottom padding so content isn't hidden behind pay button
                .padding(.bottom, Layout.buttonHeight + Layout.bottomPad + 32)
            }

            // Pinned pay button
            payButton
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.bottom, Layout.bottomPad)
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadAddresses()
        }
        // Apple Pay simulated sheet
        .sheet(isPresented: $viewModel.isApplePaySheetPresented) {
            ApplePaySimulatedSheet(
                cart: viewModel.cart,
                onConfirm: {
                    viewModel.confirmApplePay()
                },
                onCancel: {
                    viewModel.isApplePaySheetPresented = false
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
            viewModel.initiatePayment()
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
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedPaymentMethod)
    }

    private var payButtonTitle: String {
        switch viewModel.selectedPaymentMethod {
        case .applePay:
            return "Pay with Apple Pay"
        case .cashOnDelivery:
            let total = String(format: "$%.2f", viewModel.cart.cost.totalAmount)
            return "Place Order · \(total)"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CheckoutView(
            viewModel: CheckoutViewModel(
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
                placeOrderUseCase: PlaceOrderUseCase(
                    repository: CheckoutRepositoryImpl(
                        remoteDataSource: CheckoutRemoteDataSource()
                    )
                ),
                addressUseCases: AddressUseCasesImpl(
                    repository: AddressRepositoryImpl(
                        remoteDataSource: AddressRemoteDataSourceImpl(
                            client: GraphQLClient(
                                apollo: DIContainer.shared.apolloClient
                            )
                        )
                    )
                ),
                cartUseCases: CartUseCasesImpl(
                    repository: CartRepositoryImpl(
                        remoteDataSource: RemoteCartDataSourceImpl(
                            client: GraphQLClient(
                                apollo: DIContainer.shared.apolloClient
                            )
                        ),
                        commonRemoteDataSource: CommonRemoteDataSource(
                            client: GraphQLClient(
                                apollo: DIContainer.shared.apolloClient
                            )
                        )
                    )
                )
            )
        )
        .environment(AppRouter())
    }
}
