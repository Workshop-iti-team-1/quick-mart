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
        ZStack(alignment: .bottomTrailing) {
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

            AIAssistantFAB {
                router.push(.aiChat)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 24)
        }
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
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.cyanPrimary)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
    }
}



