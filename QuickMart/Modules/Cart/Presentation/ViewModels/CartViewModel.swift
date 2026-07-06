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

    // MARK: - Discount State

    @Published var showDiscountAlert = false
    @Published var discountMessage = ""

    /// Fired when a code is accepted by Shopify but conditions are not met
    @Published var showDiscountNotApplicableAlert = false
    @Published var discountNotApplicableReason = ""

    @Published var isUpdating = false
    @Published var isCheckoutUrlPresented = false

    // MARK: - Dependencies

    private let useCases: CartUseCases

    /// Used only for fetching discount summary when a code is not applicable.
    /// Lazy so it is only constructed if needed.
    private lazy var discountDataSource = DiscountDataSource()

    init(useCases: CartUseCases) {
        self.useCases = useCases
    }

    // MARK: - Load

    func loadCart() {
        if SessionManager.shared.currentState == .guest {
            viewState = .guest
            return
        }

        viewState = .loading
        errorMessage = nil

        Task {
            do {
                if let fetchedCart = try await useCases.getCart(),
                   !fetchedCart.lines.isEmpty {
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

    // MARK: - Update / Remove

    func updateQuantity(lineId: String, newQuantity: Int) {
        guard newQuantity > 0 else { return }
        isUpdating = true
        Task {
            do {
                let updatedCart = try await useCases.updateLine(
                    lineId: lineId,
                    quantity: newQuantity
                )
                self.cart = updatedCart
                NotificationCenter.default.post(
                    name: NSNotification.Name("CartUpdated"),
                    object: nil
                )
                if updatedCart.lines.isEmpty { self.viewState = .empty }
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
                NotificationCenter.default.post(
                    name: NSNotification.Name("CartUpdated"),
                    object: nil
                )
                if updatedCart.lines.isEmpty { self.viewState = .empty }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isUpdating = false
        }
    }

    // MARK: - Apply Discount

    func applyDiscount(code: String) {
        guard !code.isEmpty else { return }
        isUpdating = true

        Task {
            do {
                let updatedCart = try await useCases.applyDiscount(code: code)
                self.cart = updatedCart

                if let appliedCode = updatedCart.discountCodes.first(
                    where: { $0.code.lowercased() == code.lowercased() }
                ) {
                    if appliedCode.applicable {
                        // ✅ Discount successfully applied — totals already updated
                        self.discountMessage = AppStrings.Cart.discountAppliedMessage
                        self.showDiscountAlert = true
                    } else {
                        // ⚠️ Code accepted but conditions not met
                        // Fetch the reason from Admin API discount summary
                        await self.fetchDiscountReason(for: code)
                    }
                } else {
                    // Code not found in response at all
                    self.discountMessage = AppStrings.Cart.discountInvalidMessage
                    self.showDiscountAlert = true
                }

            } catch {
                self.errorMessage = error.localizedDescription
            }

            self.isUpdating = false
        }
    }

    // MARK: - Discount Reason Fetch

    /// Fetches the discount's summary from Admin API to surface
    /// the unmet condition to the user (e.g. "Requires at least 3 items").
    private func fetchDiscountReason(for code: String) async {
        do {
            let discounts = try await discountDataSource.fetchActiveDiscounts()

            if let match = discounts.first(
                where: { $0.code.lowercased() == code.lowercased() }
            ) {
                // Use the discount summary as the reason — it contains
                // the human-readable condition from Shopify admin
                discountNotApplicableReason = match.summary.isEmpty
                    ? AppStrings.Cart.discountInvalidMessage
                    : match.summary
            } else {
                discountNotApplicableReason = AppStrings.Cart.discountInvalidMessage
            }

        } catch {
            // Fallback to generic message if Admin API call fails
            discountNotApplicableReason = AppStrings.Cart.discountInvalidMessage
        }

        showDiscountNotApplicableAlert = true
    }

    // MARK: - Checkout

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
        NotificationCenter.default.post(
            name: NSNotification.Name("CartUpdated"),
            object: nil
        )
        loadCart()
    }
}
