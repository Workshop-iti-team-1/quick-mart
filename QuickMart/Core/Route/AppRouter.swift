//
//  AppRouter.swift
//  QuickMart
//

//  AppRouter.swift
//  QuickMart

import Observation
import SwiftUI

@Observable
final class AppRouter {

    // MARK: - State

    var path = NavigationPath()

    // 1. Add global tab state
    var selectedTab: TabItem = .home

    // 2. Add the filter mailbox
    var queuedSearchFilters: SearchFilters? = nil

    // MARK: - Dependencies
    private let diContainer: DIContainer

    // MARK: - Init
    init(diContainer: DIContainer = .shared) {
        self.diContainer = diContainer
    }

    // MARK: - Navigation Intents

    // 3. Add the tab switching method
    func switchTab(to tab: TabItem, with filters: SearchFilters? = nil) {
        if let filters = filters {
            self.queuedSearchFilters = filters
        }
        self.selectedTab = tab
        self.popToRoot()
    }

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    // MARK: - Route → View Resolution

    /// Attach this to your root NavigationStack via .navigationDestination(for: Route.self)
    @MainActor
    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: self.diContainer.makeHomeViewModel())
        case .login:
            LoginView()
        case .signup:
            SignupView(router: self)
        case .allBrands:
            AllBrandsView(viewModel: diContainer.makeBrandViewModel())
        case .category:
            AllBrandsView(viewModel: diContainer.makeBrandViewModel())
        case .categoryDetail(let item):
            CategoryDetailView(category: item)
        case .forgotPassword:
            ForgotPasswordView(router: self)
        case .productDetails(let productId):
            ProductDetailsView(
                viewModel: self.diContainer.makeProductDetailsViewModel(
                    productId: productId))
        case .cart:
            CartView(router: self)
        case .search(let filters):
            SearchView(
                viewModel: diContainer.makeSearchViewModel(
                    initialFilters: filters ?? SearchFilters()))
        case .shippingAddresses:
            AddressListView(viewModel: AddressListViewModel(useCases: self.diContainer.makeAddressUseCases()))
            // AppRouter.destination(for:) — update the .addressForm case
            case .addressForm(let address):
                AddressFormView(
                    viewModel: AddressFormViewModel(
                        useCases: self.diContainer.makeAddressUseCases(),
                        countryProvider: self.diContainer.countryDataProvider,
                        editingAddress: address
                    ),
                    router: self
                )
        case .wishlist:
            WishlistView()
        case .favoriteDetail(let product):
            ProductDetailsView(
                viewModel: self.diContainer.makeProductDetailsViewModel(productId: product.id, preloadedProduct: product)
            )
            
        case .profile:
            ProfileView(router: self)
        case .shippingAddress:
            ProfileView(router: self)
        case .paymentMethod:
            ProfileView(router: self)
        case .orderHistory:
            ProfileView(router: self)
        case .privacyPolicy:
            ProfileView(router: self)
        case .termsAndConditions:
            ProfileView(router: self)
        case .faqs:
            ProfileView(router: self)
        case .changePassword:
            ProfileView(router: self)
        }
    }
    // MARK: - Search (fullScreenCover factory)
    // Call this from any view that presents search modally:
    // .fullScreenCover(isPresented: $showSearch) { router.searchView() }

    @MainActor
    func searchView() -> SearchView {
        SearchView(
            viewModel: diContainer.makeSearchViewModel(
                initialFilters: SearchFilters()))
    }
}
