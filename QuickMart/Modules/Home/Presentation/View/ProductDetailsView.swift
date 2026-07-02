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
                    bottomBar
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                }
            }
            
            if viewModel.showToast {
                toastView
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
                imageHeader(product: product)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 8) {
                        BadgeView(text: AppStrings.ProductDetails.topRated, color: Color.cyanPrimary)
                        BadgeView(text: AppStrings.ProductDetails.freeShipping, color: Color.cyanPrimary)
                    }
                    
                    titleAndPrice(product: product)
                    ratingView(product: product)
                    descriptionView(product: product)
                    optionsView(product: product)
                    quantityView
                }
                .padding(24)
            }
        }
    }
    
    @ViewBuilder
    private func imageHeader(product: ProductDetails) -> some View {
        ZStack(alignment: .top) {
            if let imageURLStr = product.images.first?.url, let url = URL(string: imageURLStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
                .background(Color.grey50)
                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
                    .background(Color.grey50)
                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
            }
        }
    }
    
    @ViewBuilder
    private func titleAndPrice(product: ProductDetails) -> some View {
        HStack(alignment: .top) {
            Text(product.title)
                .appTextStyle(.heading2, color: Color.appBlack)
                .lineLimit(2)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", product.minPrice))")
                    .appTextStyle(.heading2, color: Color.appBlack)
                
                if let originalPrice = product.compareAtPrice {
                    Text("$\(String(format: "%.2f", originalPrice))")
                        .appTextStyle(.body, color: Color.grey150)
                        .strikethrough()
                }
            }
        }
    }
    
    @ViewBuilder
    private func ratingView(product: ProductDetails) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { i in
                Image(systemName: i < Int(product.rating) ? "star.fill" : "star")
                    .foregroundColor(Color.appYellow)
                    .font(.caption)
            }
            Text("\(String(format: "%.1f", product.rating)) (\(product.reviewsCount) reviews)")
                .appTextStyle(.label, color: Color.appBlack)
        }
    }
    
    @ViewBuilder
    private func descriptionView(product: ProductDetails) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                .appTextStyle(.body, color: Color.grey150)
                .lineLimit(4)
            
            Button(action: {}) {
                Text(AppStrings.ProductDetails.readMore)
                    .appTextStyle(.label, color: Color.cyanPrimary)
            }
        }
    }
    
    @ViewBuilder
    private func optionsView(product: ProductDetails) -> some View {
        ForEach(product.options, id: \.id) { option in
            if option.name.lowercased() == "color" && !option.values.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(AppStrings.ProductDetails.color)
                        .appTextStyle(.button, color: Color.appBlack)
                    
                    HStack(spacing: 12) {
                        ForEach(option.values, id: \.self) { colorName in
                            Circle()
                                .fill(getColor(for: colorName))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle().stroke(Color.appBlack, lineWidth: viewModel.selectedColor == colorName ? 2 : 0)
                                )
                                .onTapGesture {
                                    viewModel.selectedColor = colorName
                                }
                        }
                    }
                }
            } else if !option.values.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(option.name)
                        .appTextStyle(.button, color: Color.appBlack)
                    
                    HStack(spacing: 12) {
                        ForEach(option.values, id: \.self) { val in
                            Text(val.uppercased())
                                .appTextStyle(.label, color: viewModel.selectedSize == val ? Color.appWhite : Color.appBlack)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(viewModel.selectedSize == val ? Color.appBlack : Color.appWhite)
                                )
                                .overlay(
                                    Capsule().stroke(Color.grey100, lineWidth: viewModel.selectedSize == val ? 0 : 1)
                                )
                                .onTapGesture {
                                    viewModel.selectedSize = val
                                }
                        }
                    }
                }
            }
        }
    }
    
    private var quantityView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppStrings.ProductDetails.quantity)
                .appTextStyle(.button, color: Color.appBlack)
            
            HStack(spacing: 16) {
                Button(action: { viewModel.decrementQuantity() }) {
                    Image(systemName: "minus")
                        .foregroundColor(Color.appBlack)
                        .frame(width: 40, height: 40)
                        .background(Color.appWhite)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.grey100, lineWidth: 1))
                }
                
                Text("\(viewModel.quantity)")
                    .appTextStyle(.button, color: Color.appBlack)
                    .frame(width: 30)
                
                Button(action: { viewModel.incrementQuantity() }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.appBlack)
                        .frame(width: 40, height: 40)
                        .background(Color.appWhite)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.grey100, lineWidth: 1))
                }
            }
        }
    }
    
    private var bottomBar: some View {
        HStack(spacing: 16) {
            Button(action: {
                Task {
                    await viewModel.addToCart(buyNow: true)
                }
            }) {
                if viewModel.isAddingToCart {
                    Text(AppStrings.ProductDetails.buyNow)
                        .appTextStyle(.button, color: Color.appBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)

                } else {
                    Text(AppStrings.ProductDetails.buyNow)
                        .appTextStyle(.button, color: Color.appBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .background(Color.appWhite)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBlack, lineWidth: 1))
            .disabled(viewModel.isAddingToCart)
            
            Button(action: {
                Task {
                    await viewModel.addToCart(buyNow: false)
                }
            }) {
                HStack {
                    Text(AppStrings.ProductDetails.addToCart)
                        .appTextStyle(.button, color: Color.appWhite)
                    Image(systemName: "cart")
                        .foregroundColor(Color.appWhite)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appBlack)
                .cornerRadius(16)
            }
            .disabled(viewModel.isAddingToCart)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.appWhite)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
    }
    
    private var toastView: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.cyanPrimary)
                
                Text(AppStrings.ProductDetails.addedToCartMessage)
                    .appTextStyle(.label, color: Color.appWhite)
                
                Spacer()
                
                Button(action: {
                    viewModel.showToast = false
                    router.push(.cart)
                }) {
                    Text(AppStrings.ProductDetails.viewCart)
                        .appTextStyle(.label, color: Color.cyanPrimary)
                }
            }
            .padding()
            .background(Color.appBlack)
            .cornerRadius(12)
            .padding(.horizontal, 24)
            .padding(.top, 50)
            
            Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut, value: viewModel.showToast)
        .zIndex(2)
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
    private func getColor(for name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "gray", "grey": return .gray
        case "brown": return .brown
        case "cyan": return .cyan
        case "pink": return .pink
        case "silver": return Color(white: 0.8)
        case "gold": return Color(red: 1.0, green: 0.84, blue: 0.0)
        default: return .gray
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
