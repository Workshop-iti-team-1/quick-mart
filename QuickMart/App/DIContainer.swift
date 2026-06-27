//
//  DIContainer.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import Foundation

@MainActor
final class DIContainer {
    
    static let shared = DIContainer()
    
    // Prevent external initialization
    private init() {}
    
    // MARK: - Core / Network Infrastructure
    
    lazy var graphQLClient: ShopifyGraphQLClientProtocol = {
        // Wiring up the AppConfiguration seamlessly
        return ShopifyGraphQLClient(
            endpoint: AppConfiguration.storeURL,
            adminToken: AppConfiguration.adminAPIToken,
            apiKey: AppConfiguration.apiKey
        )
    }()
    
    // Add CoreData Stack here later if needed:
    // lazy var coreDataStack: CoreDataStack = { CoreDataStack(modelName: "QuickMart") }()
    
    // MARK: - Data Repositories
    
//    lazy var productRepository: ProductRepositoryProtocol = {
//        return ProductRepository(networkClient: graphQLClient)
//    }()
//    
//    // MARK: - Domain Use Cases
//    
//    lazy var fetchProductsUseCase: FetchProductsUseCaseProtocol = {
//        return FetchProductsUseCase(repository: productRepository)
//    }()
//    
//    // MARK: - Presentation ViewModels
//    // Note: ViewModels are generally returned via factory methods rather than lazy vars
//    // to ensure a fresh state when navigating, unless it is a global shared state (like a Cart).
//    
//    func makeHomeViewModel() -> HomeViewModel {
//        return HomeViewModel(fetchProductsUseCase: fetchProductsUseCase)
//    }
//    
//    lazy var sharedCartViewModel: CartViewModel = {
//        return CartViewModel()
//    }()
}
