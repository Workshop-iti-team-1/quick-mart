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
            TabView(selection: $bindableRouter.selectedTab) {
                HomeView(viewModel: DIContainer.shared.makeHomeViewModel())
                    .customToolbar(
                        cartCount: viewModel.cartItemCount,
                        onCart: { router.switchTab(to: .cart) }
                    )
                    .tag(TabItem.home)
                    .toolbar(.hidden, for: .tabBar)

                SearchView(viewModel: DIContainer.shared.makeSearchViewModel())
                    .tag(TabItem.search)
                    .toolbar(.hidden, for: .tabBar)

                CartView()
                    .tag(TabItem.cart)
                    .toolbar(.hidden, for: .tabBar)

                WishlistView()
                    .tag(TabItem.wishlist)
                    .toolbar(.hidden, for: .tabBar)

                ProfileView()
                    .tag(TabItem.profile)
                    .toolbar(.hidden, for: .tabBar)
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
