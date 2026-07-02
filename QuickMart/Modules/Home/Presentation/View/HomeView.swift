//
//  HomeView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @StateObject private var brandViewModel = DIContainer.shared.makeBrandViewModel()
    @StateObject private var categoryViewModel = DIContainer.shared.makeCategoryViewModel()
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                if !viewModel.banners.isEmpty {
                    AdBannerPager(items: viewModel.banners)
                }

                if !brandViewModel.brands.isEmpty {
                    HomeBrandsSection(
                        items: brandViewModel.brands,
                        onSeeAll: { router.push(.allBrands) }
                    )
                }

                if !categoryViewModel.categories.isEmpty {
                    HomeCategoriesSection(
                        items: categoryViewModel.categories,
                       
                        onCategoryTap: { router.push(.categoryDetail($0)) }
                    )
                }

                if !viewModel.latestProducts.isEmpty {
                    LatestProductsSection(
                        items: viewModel.latestProducts,
                        onSeeAll: { }
                    )
                }

                Button {
                    SessionManager.shared.logout()
                } label: {
                    Text("Test Logout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadHome()
            brandViewModel.loadBrands()
            categoryViewModel.loadCategories()
        }
    }
}
