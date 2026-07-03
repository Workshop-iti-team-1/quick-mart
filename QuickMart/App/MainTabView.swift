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
        //  Create a bindable reference for the router
        @Bindable var bindableRouter = router
        
        VStack(spacing: 0) {
            Group {
                //  Read selected tab from the router
                switch router.selectedTab {
                case .home:
                    HomeView(viewModel: DIContainer.shared.makeHomeViewModel())
                        .customToolbar(
                            cartCount: viewModel.cartItemCount,
                            // Fire router tab switch on cart tap
                            onCart: { router.switchTab(to: .cart) }
                        )
                case .search:
                    SearchView(viewModel: DIContainer.shared.makeSearchViewModel())
                case .cart:
                    CartView(router: router)
                case .wishlist:
                    Text("Wishlist")
                case .profile:
            
                    MockProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(
                selectedTab: $bindableRouter.selectedTab, //  Bind directly to router
                cartCount: viewModel.cartItemCount
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
