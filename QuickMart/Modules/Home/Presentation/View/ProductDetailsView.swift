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
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Image Header
                        ZStack(alignment: .top) {
                            if viewModel.product.isSystemImage {
                                Image(systemName: viewModel.product.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .padding()
                                    .background(Color.grey50)
                                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            } else {
                                Image(viewModel.product.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 300)
                                    .clipped()
                                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                            }
                            
                            // Top Bar (Back & Favorite)
                            HStack {
                                Button(action: { router.pop() }) {
                                    Image(systemName: "arrow.left")
                                        .font(.title2)
                                        .foregroundColor(Color.appBlack)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    // Toggle favorite
                                }) {
                                    Image(systemName: viewModel.product.isFavorite ? "heart.fill" : "heart")
                                        .font(.title2)
                                        .foregroundColor(viewModel.product.isFavorite ? .red : Color.appBlack)
                                        .padding(8)
                                        .background(Color.appWhite.opacity(0.8))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            // Badges
                            HStack(spacing: 8) {
                                BadgeView(text: AppStrings.ProductDetails.topRated, color: Color.cyanPrimary)
                                BadgeView(text: AppStrings.ProductDetails.freeShipping, color: Color.cyanPrimary)
                            }
                            
                            // Title & Price
                            HStack(alignment: .top) {
                                Text(viewModel.product.name)
                                    .appTextStyle(.heading2, color: Color.appBlack)
                                    .lineLimit(2)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("$\(String(format: "%.2f", viewModel.product.price))")
                                        .appTextStyle(.heading2, color: Color.appBlack)
                                    
                                    if let originalPrice = viewModel.product.originalPrice {
                                        Text("$\(String(format: "%.2f", originalPrice))")
                                            .appTextStyle(.body, color: Color.grey150)
                                            .strikethrough()
                                    }
                                }
                            }
                            
                            // Rating
                            HStack(spacing: 4) {
                                ForEach(0..<5) { i in
                                    Image(systemName: i < Int(viewModel.product.rating) ? "star.fill" : "star")
                                        .foregroundColor(Color.appYellow)
                                        .font(.caption)
                                }
                                Text("\(String(format: "%.1f", viewModel.product.rating)) (\(viewModel.product.reviewsCount) reviews)")
                                    .appTextStyle(.label, color: Color.appBlack)
                            }
                            
                            // Description
                            VStack(alignment: .leading, spacing: 8) {
                                Text(viewModel.product.description)
                                    .appTextStyle(.body, color: Color.grey150)
                                    .lineLimit(4)
                                
                                Button(action: {}) {
                                    Text(AppStrings.ProductDetails.readMore)
                                        .appTextStyle(.label, color: Color.cyanPrimary)
                                }
                            }
                            
                            // Color Selector
                            if !viewModel.product.colorNames.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(AppStrings.ProductDetails.color)
                                        .appTextStyle(.button, color: Color.appBlack)
                                    
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.product.colorNames, id: \.self) { colorName in
                                            Circle()
                                                .fill(Color(colorName))
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
                            }
                            
                            // Size Selector
                            if !viewModel.product.sizes.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(AppStrings.ProductDetails.size)
                                        .appTextStyle(.button, color: Color.appBlack)
                                    
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.product.sizes, id: \.self) { size in
                                            Text(size)
                                                .appTextStyle(.label, color: viewModel.selectedSize == size ? Color.appWhite : Color.appBlack)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    Capsule()
                                                        .fill(viewModel.selectedSize == size ? Color.appBlack : Color.appWhite)
                                                )
                                                .overlay(
                                                    Capsule().stroke(Color.grey100, lineWidth: viewModel.selectedSize == size ? 0 : 1)
                                                )
                                                .onTapGesture {
                                                    viewModel.selectedSize = size
                                                }
                                        }
                                    }
                                }
                            }
                            
                            // Quantity
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
                        .padding(24)
                    }
                }
                
                // Bottom Sticky Bar
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text(AppStrings.ProductDetails.buyNow)
                            .appTextStyle(.button, color: Color.appBlack)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appWhite)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBlack, lineWidth: 1))
                    }
                    
                    Button(action: { viewModel.addToCart() }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(Color.appWhite)
                            } else {
                                Text(AppStrings.ProductDetails.addToCart)
                                    .appTextStyle(.button, color: Color.appWhite)
                                Image(systemName: "cart")
                                    .foregroundColor(Color.appWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appBlack)
                        .cornerRadius(16)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.appWhite)
                .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
            }
            
            // Toast
            if viewModel.showToast {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.cyanPrimary)
                        
                        Text(AppStrings.ProductDetails.addedToCartMessage)
                            .appTextStyle(.label, color: Color.appWhite)
                        
                        Spacer()
                        
                        Button(action: {
                            // Navigate to cart or something
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
            }
        }
        .navigationBarHidden(true)
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
