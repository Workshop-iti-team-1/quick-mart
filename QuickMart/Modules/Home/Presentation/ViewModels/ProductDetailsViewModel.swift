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
    let product: ProductItem
    
    @Published var selectedColor: String?
    @Published var selectedSize: String?
    @Published var quantity: Int = 1
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showToast: Bool = false
    
    private let addToCartUseCase: AddToCartUseCaseProtocol
    
    init(product: ProductItem, addToCartUseCase: AddToCartUseCaseProtocol) {
        self.product = product
        self.addToCartUseCase = addToCartUseCase
        
        self.selectedColor = product.colorNames.first
        self.selectedSize = product.sizes.first
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    func addToCart() {
        guard !product.variantId.isEmpty else {
            errorMessage = "Invalid product ID"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await addToCartUseCase.execute(variantId: product.variantId, quantity: quantity)
                isLoading = false
                showToast = true
                
                // Hide toast after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showToast = false
                }
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
