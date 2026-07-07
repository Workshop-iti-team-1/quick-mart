//
//  ProductDetailsView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductDetailsView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    @ObservedObject private var favouriteViewModel = FavouriteViewModel.shared
    @Environment(AppRouter.self) var router

    var body: some View {
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.isLoadingProduct {
                    ProductDetailsSkeletonView()

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
                ZStack {
                    Color.black.opacity(0.1).ignoresSafeArea()
                    ProgressView()
                        .tint(.cyanPrimary)
                }
            }
        }
        .onAppear {
            viewModel.loadProduct()
        }
        .onChange(of: viewModel.navigateToCart) { newValue in
            if newValue {
                viewModel.navigateToCart = false
                router.push(.cart)
            }
        }
        .alert(
            AppStrings.General.error,
            isPresented: $viewModel.showOutOfStockAlert
        ) {
            Button(AppStrings.General.ok, role: .cancel) {}
        } message: {
            Text(AppStrings.ProductDetails.outOfStock)
        }
        .alert(
            AppStrings.ProductDetails.guestAlertTitle,
            isPresented: $viewModel.showGuestAlert
        ) {
            Button(AppStrings.General.cancel, role: .cancel) {}
            Button(AppStrings.Auth.login) {
                router.push(.login)
            }
        } message: {
            Text(AppStrings.ProductDetails.guestAlertMessage)
        }
    }

    private var appBar: some View {
        HStack {
            Spacer()
            if let product = viewModel.productDetails {
                FavoriteButton(
                    isFavorite: .init(
                        get: { favouriteViewModel.isFavorite(product.id) },
                        set: { _ in }
                    ),
                    onToggle: { newValue in
                        if newValue {
                            favouriteViewModel.addFavorite(product)
                        } else {
                            favouriteViewModel.removeFavorite(id: product.id)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .zIndex(1)
    }

    @ViewBuilder
    private func contentView(for product: ProductDetails) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ProductImageHeader(product: product)

                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 8) {
                        BadgeView(
                            text: AppStrings.ProductDetails.topRated,
                            color: Color.cyanPrimary)
                        BadgeView(
                            text: AppStrings.ProductDetails.freeShipping,
                            color: Color.cyanPrimary)
                    }

                    ProductTitleAndPrice(product: product)
                    ProductRatingView(product: product)
                    ProductDescriptionView(product: product)
                    HStack(spacing: 12) {
                        Button {
                            router.push(
                                .aiComparisonPicker(baseProduct: product))
                        } label: {
                            aiActionLabel(
                                icon: "arrow.left.arrow.right", text: "Compare")
                        }
                        Button {
                            router.push(.aiOutfit(product: product))
                        } label: {
                            aiActionLabel(
                                icon: "tshirt", text: "Complete the Look")
                        }
                    }

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
private func aiActionLabel(icon: String, text: String) -> some View {
    HStack(spacing: 6) {
        Image(systemName: icon).font(.system(size: 13, weight: .semibold))
        Text(text).appTextStyle(.label)
    }
    .foregroundColor(.cyanPrimary)
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(Color.cyan50)
    .clipShape(RoundedRectangle(cornerRadius: 10))
}
