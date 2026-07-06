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
        
        @Bindable var bindableRouter = router
        
        VStack(spacing: 0) {
            Group {
                //  Read selected tab from the router
                switch router.selectedTab {
                case .home:
                    HomeView(viewModel: DIContainer.shared.makeHomeViewModel())
                        .customToolbar(
                            cartCount: viewModel.cartItemCount,
                          
                            onCart: { router.switchTab(to: .cart) }
                        )
                case .search:
                    SearchView(viewModel: DIContainer.shared.makeSearchViewModel())
                case .cart:
                    CartView()
                case .wishlist:
                    WishlistView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(
                selectedTab: $bindableRouter.selectedTab,
                cartCount: viewModel.cartItemCount
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
