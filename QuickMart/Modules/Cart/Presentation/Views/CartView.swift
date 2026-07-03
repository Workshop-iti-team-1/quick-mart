//
//  CartView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI
import SafariServices

struct CartView: View {
    @StateObject private var viewModel = DIContainer.shared.makeCartViewModel()
    @State private var showVoucherSheet = false
    let router: AppRouter
    
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

                    router.popToRoot()
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
        .sheet(isPresented: $viewModel.isCheckoutUrlPresented, onDismiss: {
            viewModel.clearCartAfterCheckout()
        }) {
            if let cart = viewModel.cart, let url = URL(string: cart.checkoutUrl) {
                SafariView(url: url)
            }
        }
    }
    
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
                                    viewModel.updateQuantity(lineId: item.id, newQuantity: item.quantity + 1)
                                },
                                onDecrement: {
                                    viewModel.updateQuantity(lineId: item.id, newQuantity: item.quantity - 1)
                                },
                                onDelete: {
                                    viewModel.removeLine(lineId: item.id)
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 120) 
                }
                
                OrderSummaryView(
                    cost: cart.cost,
                    itemCount: cart.totalQuantity,
                    onCheckout: {
                        viewModel.checkout()
                    }
                )
            }
        }
    }
}


struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // No update needed
    }
}
