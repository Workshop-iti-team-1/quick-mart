//
//  AppRouter.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
// App/AppRouter.swift
import SwiftUI
import Observation


@Observable
final class AppRouter {
    
    var path = NavigationPath()
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer = .shared) {
        self.diContainer = diContainer
    }
    
    // MARK: - Navigation Intents
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    // MARK: - View Resolution
    
//    @MainActor
//    @ViewBuilder
//    func resolve(_ route: Route) -> some View {
//        switch route {
//        case .home:
//            HomeView(viewModel: diContainer.makeHomeViewModel())
//            
//        case .productDetail(let productId):
//            ProductDetailView(
//                viewModel: ProductDetailViewModel(
//                    productId: productId,
//                    repository: diContainer.productRepository // Inject repository directly if skipping use-case for simple fetches
//                )
//            )
//            
//        case .cart:
//            CartView(viewModel: diContainer.sharedCartViewModel)
//        }
//    }
}
