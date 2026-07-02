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

    // MARK: - Dependencies

    private let diContainer: DIContainer

    // MARK: - Init

    init(diContainer: DIContainer = .shared) {
        self.diContainer = diContainer
    }

    // MARK: - Navigation Intents

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
        case .search:
            // Search is fullScreenCover — this path handles deep-link push edge cases
            SearchView(viewModel: diContainer.makeSearchViewModel())
        }
    }
    // MARK: - Search (fullScreenCover factory)
    // Call this from any view that presents search modally:
    // .fullScreenCover(isPresented: $showSearch) { router.searchView() }

    @MainActor
    func searchView() -> SearchView {
        SearchView(viewModel: diContainer.makeSearchViewModel())
    }
}
