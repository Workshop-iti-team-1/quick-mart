//
//  AppRouter.swift
//  QuickMart
//

//  AppRouter.swift
//  QuickMart

import SwiftUI
import Observation

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
            HomeView(viewModel: self.diContainer.makeHomeViewModel(), router: self)
        case .login:
            LoginView(router: self)
        case .signup:
            SignupView(router: self)
        case .category:
            CategoryView(viewModel: diContainer.makeCategoryViewModel())
        }
    }
}
