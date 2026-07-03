//
//  RootViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation

@MainActor
final class RootViewModel: ObservableObject {

    @Published var cartItemCount: Int = 0
    private let cartUseCases: CartUseCases

    init(cartUseCases: CartUseCases) {
        self.cartUseCases = cartUseCases
        Task { await fetchCartCount() }

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("CartUpdated"), object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { await self?.fetchCartCount() }
        }
    }

    private func fetchCartCount() async {
        do {
            if let cart = try await cartUseCases.getCart() {
                self.cartItemCount = cart.totalQuantity
            } else {
                self.cartItemCount = 0
            }
        } catch {
            print("Failed to fetch cart count: \(error)")
        }
    }
}
