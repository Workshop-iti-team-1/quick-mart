//
//  CartView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//
// Features/Cart/Presentation/Views/CartView.swift

import SwiftUI
import SafariServices

struct CartView: View {
    @StateObject private var viewModel = DIContainer.shared.makeCartViewModel()
    @State private var showVoucherSheet = false
    @State private var showDeleteConfirmation = false
    @State private var itemToDeleteId: String?
    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            switch viewModel.viewState {
            case .loading:
                CustomLoadingView()
            case .guest:
                GuestCartView {
                    router.push(.login)
                }
            case .empty:
                EmptyCartView {
                    router.push(.allBrands)
                }
            case .populated:
                populatedCartView
            }

            if viewModel.isUpdating {
                CustomLoadingView()
            }
        }
        .onAppear {
            viewModel.loadCart()
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showError) {
            Button(AppStrings.General.ok, role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert(AppStrings.General.success, isPresented: $viewModel.showDiscountAlert) {
            Button(AppStrings.General.ok, role: .cancel) { }
        } message: {
            Text(viewModel.discountMessage)
        }
        .sheet(isPresented: $showVoucherSheet) {
            if #available(iOS 16.0, *) {
                VoucherBottomSheet(isPresented: $showVoucherSheet) { code in
                    viewModel.applyDiscount(code: code)
                }
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
            } else {
                VoucherBottomSheet(isPresented: $showVoucherSheet) { code in
                    viewModel.applyDiscount(code: code)
                }
            }
        }
        .sheet(isPresented: $showDeleteConfirmation) {
            if #available(iOS 16.0, *) {
                CartDeleteConfirmationSheet(
                    isPresented: $showDeleteConfirmation,
                    onDelete: {
                        if let id = itemToDeleteId {
                            viewModel.removeLine(lineId: id)
                            itemToDeleteId = nil
                        }
                    }
                )
                .presentationDetents([.height(250)])
                .presentationDragIndicator(.visible)
            } else {
                CartDeleteConfirmationSheet(
                    isPresented: $showDeleteConfirmation,
                    onDelete: {
                        if let id = itemToDeleteId {
                            viewModel.removeLine(lineId: id)
                            itemToDeleteId = nil
                        }
                    }
                )
            }
        }
    }

    // MARK: - Populated Cart

    private var populatedCartView: some View {
        VStack(spacing: 0) {
            HStack {
                Text(AppStrings.Cart.myCart)
                    .appTextStyle(.heading2, color: .primary)

                Spacer()

                Button(action: { showVoucherSheet = true }) {
                    Text(AppStrings.Cart.voucherCode)
                        .appTextStyle(.body, color: .cyanPrimary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)

            if let cart = viewModel.cart {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(cart.lines) { item in
                            CartItemRowView(
                                item: item,
                                onIncrement: {
                                    viewModel.updateQuantity(
                                        lineId: item.id,
                                        newQuantity: item.quantity + 1
                                    )
                                },
                                onDecrement: {
                                    viewModel.updateQuantity(
                                        lineId: item.id,
                                        newQuantity: item.quantity - 1
                                    )
                                },
                                onDelete: {
                                    itemToDeleteId = item.id
                                    showDeleteConfirmation = true
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }

                // Proceed to Checkout — pushes CheckoutView with current cart
                OrderSummaryView(
                    cost: cart.cost,
                    itemCount: cart.totalQuantity,
                    onCheckout: {
                        // Fix: push checkout route with cart instead of opening WebView
                        router.push(.checkout(cart))
                    }
                )
            }
        }
    }
}

// MARK: - Safari View (kept for reference — no longer used for checkout)

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {}
}
