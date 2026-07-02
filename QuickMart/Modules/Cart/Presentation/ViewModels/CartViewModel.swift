//
//  CartViewModel.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation
import Combine

enum CartViewState {
    case loading
    case guest
    case empty
    case populated
}

@MainActor
final class CartViewModel: ObservableObject {
    @Published var cart: Cart?
    @Published var viewState: CartViewState = .loading
    @Published var errorMessage: String? {
        didSet { showError = errorMessage != nil }
    }
    @Published var showError = false
    @Published var showDiscountAlert = false
    @Published var discountMessage = ""
    @Published var isUpdating = false
    @Published var isCheckoutUrlPresented = false
    
    private let useCases: CartUseCases
    
    init(useCases: CartUseCases) {
        self.useCases = useCases
    }
    
    func loadCart() {
        if SessionManager.shared.currentState == .guest {
            viewState = .guest
            return
        }
        
        viewState = .loading
        errorMessage = nil
        
        Task {
            do {
                if let fetchedCart = try await useCases.getCart(), !fetchedCart.lines.isEmpty {
                    self.cart = fetchedCart
                    self.viewState = .populated
                } else {
                    self.cart = nil
                    self.viewState = .empty
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.viewState = .empty
            }
        }
    }
    
    func updateQuantity(lineId: String, newQuantity: Int) {
        guard newQuantity > 0 else { return }
        isUpdating = true
        Task {
            do {
                let updatedCart = try await useCases.updateLine(lineId: lineId, quantity: newQuantity)
                self.cart = updatedCart
                NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
                if updatedCart.lines.isEmpty {
                    self.viewState = .empty
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isUpdating = false
        }
    }
    
    func removeLine(lineId: String) {
        isUpdating = true
        Task {
            do {
                let updatedCart = try await useCases.removeLine(lineId: lineId)
                self.cart = updatedCart
                NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
                if updatedCart.lines.isEmpty {
                    self.viewState = .empty
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isUpdating = false
        }
    }
    
    func applyDiscount(code: String) {
        guard !code.isEmpty else { return }
        isUpdating = true
        Task {
            do {
                let updatedCart = try await useCases.applyDiscount(code: code)
                self.cart = updatedCart
                self.discountMessage = AppStrings.Cart.discountAppliedMessage
                self.showDiscountAlert = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isUpdating = false
        }
    }
    
    func checkout() {
        guard let checkoutUrl = cart?.checkoutUrl, !checkoutUrl.isEmpty else {
            errorMessage = "Checkout URL not available."
            return
        }
        isCheckoutUrlPresented = true
    }
    
    func clearCartAfterCheckout() {
        useCases.clearCart()
        cart = nil
        viewState = .empty
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
        loadCart() // This will create a new cart when needed next time
    }
}
