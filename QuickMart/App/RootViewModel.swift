//
//  RootViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//
import Foundation
import Combine

@MainActor
final class RootViewModel: ObservableObject {

    @Published var cartItemCount: Int = 0
    private let cartUseCases: CartUseCases
    private var cancellables = Set<AnyCancellable>()

    init(cartUseCases: CartUseCases) {
        self.cartUseCases = cartUseCases
        Task { await fetchCartCount() }
        setupBindings()
    }
    
    private func setupBindings() {
        CartEventsBus.shared.cartUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.fetchCartCount() }
            }
            .store(in: &cancellables)
            
        CartEventsBus.shared.cartCleared
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cartItemCount = 0
            }
            .store(in: &cancellables)
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
