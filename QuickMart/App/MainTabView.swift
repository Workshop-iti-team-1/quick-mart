//
//  MainTabView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = DIContainer.shared.makeRootViewModel()
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch viewModel.selectedTab {
                case .home:
                    HomeView(viewModel: DIContainer.shared.makeHomeViewModel())
                        .customToolbar(
                            cartCount: viewModel.cartItemCount,
                            onCart: { viewModel.select(.cart) }
                        )
                case .search:
                    SearchView(viewModel: DIContainer.shared.makeSearchViewModel())
                case .cart:
                    CartView(router: router)
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
