//
//  HomeView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @StateObject private var brandViewModel = DIContainer.shared
        .makeBrandViewModel()
    @StateObject private var categoryViewModel = DIContainer.shared
        .makeCategoryViewModel()
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
                        onSeeAll: { router.push(.allBrands) },
                        onBrandTap: { brand in
                            var filters = SearchFilters()
                            filters.selectedBrandIDs.insert(brand.name)
                            router.switchTab(to: .search, with: filters)
                        }
                    )
                }

                if !categoryViewModel.categories.isEmpty {
                    HomeCategoriesSection(
                        items: categoryViewModel.categories,
                        onCategoryTap: { category in
                            var filters = SearchFilters()
                            filters.selectedCategoryIDs.insert(
                                category.handle ?? category.name.lowercased()
                            )
                            router.switchTab(to: .search, with: filters)
                        }
                    )
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
