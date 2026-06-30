//
//  DIContainer.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

// App/DI/DIContainer.swift

import Foundation
import Apollo

@MainActor
public final class DIContainer {

    public static let shared = DIContainer()

    private init() {}
    
    private(set) lazy var apolloClient: ApolloClient = {
        let store = ApolloStore()
        let provider = NetworkInterceptorProvider(client: URLSessionClient(), store: store)
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: ShopifyConfig.storeURL)
        return ApolloClient(networkTransport: transport, store: store)
    }()

    // MARK: - Category

    private func makeCategoryRepository() -> CategoryRepositoryProtocol {
        MockCategoryRepository()
    }

    private func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: makeCategoryRepository())
    }

    func makeCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(fetchCategoriesUseCase: makeFetchCategoriesUseCase())
    }
    // MARK: - Home
       private func makeHomeRepository() -> HomeRepositoryProtocol {
           MockHomeRepository()
       }
       private func makeFetchBannersUseCase() -> FetchBannersUseCaseProtocol {
           FetchBannersUseCase(repository: makeHomeRepository())
       }
       private func makeFetchLatestProductsUseCase() -> FetchLatestProductsUseCaseProtocol {
           FetchLatestProductsUseCase(repository: makeHomeRepository())
       }
       func makeHomeViewModel() -> HomeViewModel {
           HomeViewModel(
               fetchBannersUseCase: makeFetchBannersUseCase(),
               fetchLatestProductsUseCase: makeFetchLatestProductsUseCase()
           )
       }
}
