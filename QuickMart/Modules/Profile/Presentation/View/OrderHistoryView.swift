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

            // MARK: - Tab Selector

            HStack(spacing: 0) {
                ForEach(OrderTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation { viewModel.selectedTab = tab }
                    } label: {
                        HStack(spacing: 6) {
                            Text(tab.title)
                                .appTextStyle(
                                    .body,
                                    color: viewModel.selectedTab == tab
                                        ? .appWhite
                                        : .appBlack
                                )

                            let count = tabCount(for: tab)
                            if count > 0 {
                                Text("\(count)")
                                    .appTextStyle(
                                        .caption,
                                        color: viewModel.selectedTab == tab
                                            ? .appWhite
                                            : .grayText
                                    )
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        viewModel.selectedTab == tab
                                            ? Color.appWhite.opacity(0.25)
                                            : Color.grey100
                                    )
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            viewModel.selectedTab == tab
                                ? Color.appBlack
                                : Color.clear
                        )
                        .cornerRadius(12)
                    }
                }
            }
            .padding(4)
            .background(Color.grey50)
            .cornerRadius(16)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            // MARK: - Content
            if viewModel.isLoading {
                // Detailed Order History Skeleton
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: 12) {
                                // Fake Header (Order #, Badges, Date)
                                HStack(alignment: .top, spacing: 8) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        RoundedRectangle(cornerRadius: 4).fill(
                                            Color.shimmerBase
                                        ).frame(width: 100, height: 16)
                                        HStack(spacing: 6) {
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.shimmerBase).frame(
                                                    width: 60, height: 24)
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.shimmerBase).frame(
                                                    width: 80, height: 24)
                                        }
                                    }
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4).fill(
                                        Color.shimmerBase
                                    ).frame(width: 80, height: 14)
                                }

                                Divider()

                                // Fake Product Row
                                HStack(alignment: .top, spacing: 12) {
                                    RoundedRectangle(cornerRadius: 12).fill(
                                        Color.shimmerBase
                                    ).frame(width: 80, height: 80)

                                    VStack(alignment: .leading, spacing: 8) {
                                        RoundedRectangle(cornerRadius: 4).fill(
                                            Color.shimmerBase
                                        ).frame(width: 160, height: 16)
                                        RoundedRectangle(cornerRadius: 4).fill(
                                            Color.shimmerBase
                                        ).frame(width: 60, height: 12)
                                        RoundedRectangle(cornerRadius: 4).fill(
                                            Color.shimmerBase
                                        ).frame(width: 80, height: 14)
                                        RoundedRectangle(cornerRadius: 4).fill(
                                            Color.shimmerBase
                                        ).frame(width: 40, height: 12).padding(
                                            .top, 4)
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.appWhite)
                            .cornerRadius(16)
                            .shadow(
                                color: Color.appBlack.opacity(0.02), radius: 5,
                                x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .padding(.bottom, 24)
                }
                .redacted(reason: .placeholder)
                .shimmer()

            } else if let error = viewModel.error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.appOrange)

                    Text("Failed to load orders")
                        .appTextStyle(.heading2, color: .appBlack)

                    Text(error.localizedDescription)
                        .appTextStyle(.body, color: .grayText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button("Try Again") {
                        viewModel.fetchOrders()
                    }
                    .appTextStyle(.label, color: .cyanPrimary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else {
                let currentOrders =
                    viewModel.selectedTab == .ongoing
                    ? viewModel.ongoingOrders
                    : viewModel.completedOrders

                if currentOrders.isEmpty {
                    EmptyOrderView(
                        isCompleted: viewModel.selectedTab == .completed
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(currentOrders) { order in
                                // Each line item gets its own card.
                                // Tapping any card for an order navigates
                                // to the full order detail screen.
                                ForEach(order.lineItems) { item in
                                    Button {
                                        router.push(.orderDetail(order))
                                    } label: {
                                        OrderCardView(order: order, item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .padding(.bottom, 24)
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

    // MARK: - Helpers

    private func tabCount(for tab: OrderTab) -> Int {
        switch tab {
        case .ongoing: return viewModel.ongoingOrders.count
        case .completed: return viewModel.completedOrders.count
        }
    }
}
