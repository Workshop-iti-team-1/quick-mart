//
//  OrderHistoryView.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject private var viewModel: OrderHistoryViewModel
    @Environment(AppRouter.self) private var router
    
    init(viewModel: OrderHistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {

            HStack {
                ForEach(OrderTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedTab = tab
                        }
                    }) {
                        Text(tab.title)
                            .appTextStyle(.body, color: viewModel.selectedTab == tab ? .appDarkBlack : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(viewModel.selectedTab == tab ? Color.appBlack : Color.clear)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(4)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Content
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                let currentOrders = viewModel.selectedTab == .ongoing ? viewModel.ongoingOrders : viewModel.completedOrders
                
                if currentOrders.isEmpty {
                    EmptyOrderView(isCompleted: viewModel.selectedTab == .completed)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(currentOrders) { order in
                                ForEach(order.lineItems) { item in
                                    OrderCardView(order: order, item: item)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(AppStrings.Profile.orderHistory)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchOrders()
        }
    }
}
