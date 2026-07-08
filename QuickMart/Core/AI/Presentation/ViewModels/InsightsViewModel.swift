//
//  InsightsViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

@MainActor
final class InsightsViewModel: ObservableObject {
    @Published private(set) var result: AIInsightsResult?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let insightsUseCase: GenerateInsightsUseCaseProtocol
    private let getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol
    private let cartUseCases: CartUseCases

    init(
        insightsUseCase: GenerateInsightsUseCaseProtocol,
        getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol,
        cartUseCases: CartUseCases
    ) {
        self.insightsUseCase = insightsUseCase
        self.getCustomerOrdersUseCase = getCustomerOrdersUseCase
        self.cartUseCases = cartUseCases
    }

    func loadInsights() {
        guard result == nil, !isLoading else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let ordersResponse = try await getCustomerOrdersUseCase.execute(first: 20, after: nil)

                var cart: Cart? = nil
                if SessionManager.shared.currentState != .guest {
                    cart = try? await cartUseCases.getCart() // best-effort — insights still work without it
                }

                result = try await insightsUseCase.execute(cart: cart, orders: ordersResponse.orders)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
