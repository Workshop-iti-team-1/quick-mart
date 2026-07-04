//
//  ProductDetailsView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductDetailsView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    @ObservedObject private var favouriteViewModel = FavouriteViewModel.shared   // ← added
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if viewModel.isLoadingProduct {
                    Spacer()
                    CustomLoadingView()
                    Spacer()
                } else if let product = viewModel.productDetails {
                    contentView(for: product)
                    ProductBottomBar(viewModel: viewModel)
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                appBar
                Spacer()
            }
            
            if viewModel.showToast {
                ProductToastView(viewModel: viewModel)
            }
            
            if viewModel.isAddingToCart {
                CustomLoadingView()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadProduct()
        }
        .onChange(of: viewModel.navigateToCart) { newValue in
            if newValue {
                viewModel.navigateToCart = false
                router.push(.cart)
            }
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showOutOfStockAlert) {
            Button(AppStrings.General.ok, role: .cancel) { }
        } message: {
            Text(AppStrings.ProductDetails.outOfStock)
        }
        .alert(AppStrings.ProductDetails.guestAlertTitle, isPresented: $viewModel.showGuestAlert) {
            Button(AppStrings.General.cancel, role: .cancel) { }
            Button(AppStrings.Auth.login) {
                router.push(.login)
            }
        } message: {
            Text(AppStrings.ProductDetails.guestAlertMessage)
        }
    }

    private var appBar: some View {
        HStack {
            Button(action: { router.pop() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.backward").font(.system(size: 20, weight: .semibold))
                }
                .foregroundColor(.appBlack)
                .padding(8)
            }
            Spacer()
            if let product = viewModel.productDetails {
                FavoriteButton(
                    isFavorite: .init(
                        get: { favouriteViewModel.isFavorite(product.id) },   // ← reads the OBSERVED instance
                        set: { _ in }
                    ),
                    onToggle: { newValue in
                        if newValue {
                            favouriteViewModel.addFavorite(product)           // ← same
                        } else {
                            favouriteViewModel.removeFavorite(id: product.id) // ← same
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .zIndex(1)
    }
    
    @ViewBuilder
    private func contentView(for product: ProductDetails) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ProductImageHeader(product: product)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 8) {
                        BadgeView(text: AppStrings.ProductDetails.topRated, color: Color.cyanPrimary)
                        BadgeView(text: AppStrings.ProductDetails.freeShipping, color: Color.cyanPrimary)
                    }
                    
                    ProductTitleAndPrice(product: product)
                    ProductRatingView(product: product)
                    ProductDescriptionView(product: product)
                    ProductOptionsView(product: product, viewModel: viewModel)
                    ProductQuantityView(viewModel: viewModel)
                }
                .padding(24)
                .background(Color.backGround)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .padding(.top, -24)
            }
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            Text("Error: \(message)")
                .foregroundColor(.red)
                .padding()
            Button("Retry") {
                viewModel.loadProduct()
            }
            Spacer()
        }
    }
}


struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .appTextStyle(.label, color: .white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(4)
    }
}
