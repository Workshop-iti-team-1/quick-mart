//
//  ProductDetailsView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductDetailsView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    @Environment(AppRouter.self) var router
    
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            
            VStack(spacing: 0) {
                appBar
                
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
    }
    
    // MARK: - Subviews
    
    private var appBar: some View {
        HStack {
            Button(action: { router.pop() }) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(Color.appBlack)
                    .padding(8)
                    .background(Color.appWhite)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4)
            }
            Spacer()
            Button(action: {
                if viewModel.productDetails != nil {
                    viewModel.productDetails?.isFavorite.toggle()
                }
            }) {
                Image(systemName: (viewModel.productDetails?.isFavorite ?? false) ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor((viewModel.productDetails?.isFavorite ?? false) ? .red : Color.appBlack)
                    .padding(8)
                    .background(Color.appWhite)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4)
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
            VStack(alignment: .leading, spacing: 16) {
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
