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

    private var showSkeleton: Bool {
        (viewModel.isLoading && viewModel.banners.isEmpty) ||
        (brandViewModel.isLoading && brandViewModel.brands.isEmpty) ||
        (categoryViewModel.isLoading && categoryViewModel.categories.isEmpty)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if showSkeleton {
                HomeSkeletonView()
            } else {
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
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backGround.ignoresSafeArea())
            } // Close else block

            AIAssistantFAB {
                router.push(.aiChat)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.loadHome()
            brandViewModel.loadBrands()
            categoryViewModel.loadCategories()
        }
    }
}

struct AIAssistantFAB: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.appWhite)
                .frame(width: 56, height: 56)
                .background(Color.cyanPrimary)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
    }
}
