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

    var selectedTab: TabItem = .home

    var queuedSearchFilters: SearchFilters? = nil

    // MARK: - Dependencies
    private let diContainer: DIContainer

    // MARK: - Init
    init(diContainer: DIContainer = .shared) {
        self.diContainer = diContainer
    }

    // MARK: - Navigation Intents

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

    @MainActor
    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: self.diContainer.makeHomeViewModel())
        case .login:
            LoginView()
        case .signup:
            SignupView()
        case .allBrands:
            AllBrandsView(viewModel: diContainer.makeBrandViewModel())
        case .category:
            AllBrandsView(viewModel: diContainer.makeBrandViewModel())
        case .forgotPassword:
            ForgotPasswordView(router: self)
        case .productDetails(let productId):
            ProductDetailsView(
                viewModel: self.diContainer.makeProductDetailsViewModel(
                    productId: productId))
        case .cart:
            CartView()
        case .search(let filters):
            SearchView(
                viewModel: diContainer.makeSearchViewModel(
                    initialFilters: filters ?? SearchFilters()))
        case .shippingAddresses:
            AddressListView(
                viewModel: AddressListViewModel(
                    useCases: self.diContainer.makeAddressUseCases()))
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
                viewModel: self.diContainer.makeProductDetailsViewModel(
                    productId: product.id, preloadedProduct: product)
            )

        case .profile:
            ProfileView()
        case .userInfo(let user):
            UserInfoView(
                viewModel: diContainer.makeUserInfoViewModel(user: user))
        case .shippingAddress:
            ProfileView()
        case .paymentMethod:
            ProfileView()
        case .orderHistory:
            OrderHistoryView(viewModel: diContainer.makeOrderHistoryViewModel())
        case .privacyPolicy:
            PrivacyPolicyView()
        case .termsAndConditions:
            TermsAndConditionsView()
        case .faqs:
            FAQsView()
        case .changePassword:
            ProfileView()
        case .currencyPicker:
            CurrencyPickerView(viewModel: CurrencyPickerViewModel())
        case .checkout(let cart):
            CheckoutView(
                viewModel: diContainer.makeCheckoutViewModel(cart: cart)
            )
        case .orderSuccess(let order):
            OrderSuccessView(order: order)
        case .orderDetail(let order):
            OrderDetailView(order: order)
        case .aiChat:
            ChatView(viewModel: self.diContainer.makeChatViewModel())
        case .aiComparison(let products):
            ComparisonView(
                viewModel: self.diContainer.makeComparisonViewModel(
                    products: products))
        case .aiImageSearch:
            ImageSearchView(
                viewModel: self.diContainer.makeImageSearchViewModel())
        case .aiOutfit(let product):
            OutfitView(
                viewModel: self.diContainer.makeOutfitViewModel(
                    product: product))
        case .aiInsights:
            InsightsView(viewModel: self.diContainer.makeInsightsViewModel())
        case .aiComparisonPicker(let baseProduct):
            ComparisonPickerView(baseProduct: baseProduct)
        }
    }

    // MARK: - Search (fullScreenCover factory)

    @MainActor
    func searchView() -> SearchView {
        SearchView(
            viewModel: diContainer.makeSearchViewModel(
                initialFilters: SearchFilters()))
    }
}
