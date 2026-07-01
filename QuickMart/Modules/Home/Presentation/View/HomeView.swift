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
    let router: AppRouter

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                if !viewModel.banners.isEmpty {
                    AdBannerPager(items: viewModel.banners)
                }
                if !brandViewModel.brands.isEmpty {
                    HomeCategoriesSection(
                        items: brandViewModel.brands,
                        onSeeAll: { router.push(.category) }
                    )
                }
                if !viewModel.latestProducts.isEmpty {
                    LatestProductsSection(
                        items: viewModel.latestProducts,
                        onSeeAll: { }
                    )
                }
                
            
                Button(action: {
                    SessionManager.shared.logout()
                }) {
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
        .customToolbar(onSearch: {  })
        .onAppear {
            viewModel.loadHome()
            brandViewModel.loadBrands()
        }
    }
}
