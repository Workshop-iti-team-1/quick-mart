//
//  OrderHistoryViewModel.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Combine
import Foundation

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
    @Published var sortOption: OrderSortOption = .newestFirst

    private let getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(getCustomerOrdersUseCase: GetCustomerOrdersUseCaseProtocol) {
        self.getCustomerOrdersUseCase = getCustomerOrdersUseCase
        observeOrderPlacement()
    }

    // MARK: - Immediate refresh after checkout
     func observeOrderPlacement() {
        OrderEventsBus.shared.orderPlaced
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                print("executing observeOrderPlacement()...")
                self.fetchOrders()
            }
            .store(in: &cancellables)
    }

    var ongoingOrders: [OrderEntity] {
        sortOption.sort(orders.filter { !$0.isCompleted })
    }

    var completedOrders: [OrderEntity] {
        sortOption.sort(orders.filter { $0.isCompleted })
    }

    func fetchOrders() {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        Task {
            do {
                print("executing fetchOrders()...")
                let response = try await getCustomerOrdersUseCase.execute(
                    first: 20, after: nil)
                var seen = Set<String>()
                self.orders = response.orders.filter {
                    seen.insert($0.id).inserted
                }
                self.isLoading = false
            } catch {
                self.error = error
                self.isLoading = false
            }
        }
    }
}
