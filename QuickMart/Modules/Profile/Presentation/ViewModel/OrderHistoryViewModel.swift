//
//  OrderHistoryViewModel.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation
import Combine

enum OrderTab: CaseIterable {
    case ongoing
    case completed
    
    var title: String {
        switch self {
        case .ongoing: return AppStrings.Profile.ongoing
        case .completed: return AppStrings.Profile.completed
        }
    }
}

@MainActor
class OrderHistoryViewModel: ObservableObject {
    @Published var selectedTab: OrderTab = .ongoing
    @Published var orders: [OrderEntity] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol
    
    init(getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol) {
        self.getCustomerOrdersUseCase = getCustomerOrdersUseCase
    }
    
    var ongoingOrders: [OrderEntity] {
        orders.filter { !$0.isCompleted }
    }
    
    var completedOrders: [OrderEntity] {
        orders.filter { $0.isCompleted }
    }
    
    func fetchOrders() {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        
        Task {
            do {
                let response = try await getCustomerOrdersUseCase.execute(first: 20, after: nil)
                self.orders = response.orders
                self.isLoading = false
            } catch {
                self.error = error
                self.isLoading = false
            }
        }
    }
}
