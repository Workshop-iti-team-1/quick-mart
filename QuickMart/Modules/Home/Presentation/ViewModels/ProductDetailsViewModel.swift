//
//  ProductDetailsViewModel.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation
import Combine

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    let productId: String
    
    @Published var productDetails: ProductDetails?
    @Published var selectedColor: String?
    @Published var selectedSize: String?
    @Published var quantity: Int = 1
    
    @Published var isLoadingProduct: Bool = false
    @Published var isAddingToCart: Bool = false
    @Published var errorMessage: String?
    @Published var showToast: Bool = false
    @Published var navigateToCart: Bool = false
    @Published var showOutOfStockAlert: Bool = false
    @Published var showGuestAlert: Bool = false
    
    private let getProductDetailsUseCase: GetProductDetailsUseCaseProtocol
    private let addToCartUseCase: AddToCartUseCaseProtocol
    
    let favouriteViewModel: FavouriteViewModel

    init(productId: String, getProductDetailsUseCase: GetProductDetailsUseCaseProtocol,
         addToCartUseCase: AddToCartUseCaseProtocol, preloadedProduct: ProductDetails? = nil,
         favouriteViewModel: FavouriteViewModel = .shared) {
        self.productId = productId
        self.getProductDetailsUseCase = getProductDetailsUseCase
        self.addToCartUseCase = addToCartUseCase
        self.productDetails = preloadedProduct
        self.favouriteViewModel = favouriteViewModel
    }

    func loadProduct() {
        if productDetails != nil { return }
        isLoadingProduct = true
        errorMessage = nil
        Task {
            do {
                let details = try await getProductDetailsUseCase.execute(id: productId)
                self.productDetails = details
                FavouriteViewModel.shared.syncIfFavorite(details)
                isLoadingProduct = false
            } catch {
                isLoadingProduct = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    private var selectedVariantId: String? {
        guard let productDetails = productDetails else { return nil }
        
        // Find the variant that matches selected options
        return productDetails.variants.first { variant in
            let matchesColor = selectedColor == nil || variant.selectedOptions.contains { $0.name.lowercased() == "color" && $0.value == selectedColor }
            let matchesSize = selectedSize == nil || variant.selectedOptions.contains { $0.name.lowercased() == "size" && $0.value == selectedSize }
            return matchesColor && matchesSize
        }?.id ?? productDetails.variants.first?.id
    }
    
    func addToCart(buyNow: Bool = false) async {
        guard !isAddingToCart else { return }

        if SessionManager.shared.currentState == .guest {
            showGuestAlert = true
            return
        }
        
        guard let variantId = selectedVariantId else {
            errorMessage = AppStrings.ProductDetails.selectOptionsFirst
            return
        }
        
        if let variant = productDetails?.variants.first(where: { $0.id == variantId }) {
            if !variant.availableForSale {
                showOutOfStockAlert = true
                return
            }
        }
        
        isAddingToCart = true
        errorMessage = nil
        
        do {
            try await addToCartUseCase.execute(variantId: variantId, quantity: quantity)
            isAddingToCart = false
            CartEventsBus.shared.cartUpdated.send()
            if buyNow {
                navigateToCart = true
            } else {
                showToast = true
                // Hide toast after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showToast = false
                }
            }
        } catch {
            isAddingToCart = false
            errorMessage = error.localizedDescription
        }
    }
}
