//
//  InsightsViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  InsightsViewModel.swift
//  QuickMart
//
import Foundation

@MainActor
final class InsightsViewModel: ObservableObject {
    @Published private(set) var resultText: String?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let insightsUseCase: GenerateInsightsUseCaseProtocol
    private let getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol

    init(insightsUseCase: GenerateInsightsUseCaseProtocol, getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol) {
        self.insightsUseCase = insightsUseCase
        self.getCustomerOrdersUseCase = getCustomerOrdersUseCase
    }

    func loadInsights() {
        guard resultText == nil, !isLoading else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let response = try await getCustomerOrdersUseCase.execute(first: 20, after: nil)
                resultText = try await insightsUseCase.execute(orders: response.orders)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
