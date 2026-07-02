//
//  MainTabView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = RootViewModel()
    let router: AppRouter

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch viewModel.selectedTab {
                case .home:
                    HomeView(
                        viewModel: DIContainer.shared.makeHomeViewModel(),
                        router: router
                    )
                    .customToolbar(
                        cartCount: viewModel.cartItemCount,
                        onCart: { viewModel.select(.cart) }
                    )
                case .search:
                    Text("Search")
                case .cart:
                    Text("My Cart")
                case .wishlist:
                    Text("Wishlist")
                case .profile:
                    Text("Profile")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(
                selectedTab: $viewModel.selectedTab,
                cartCount: viewModel.cartItemCount
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}