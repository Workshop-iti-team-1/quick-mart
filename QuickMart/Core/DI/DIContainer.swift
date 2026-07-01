//
//  DIContainer.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

// App/DI/DIContainer.swift

import Apollo
import Foundation

@MainActor
public final class DIContainer {

    public static let shared = DIContainer()

    private init() {}

    private(set) lazy var apolloClient: ApolloClient = {
        let store = ApolloStore()
        let provider = NetworkInterceptorProvider(
            client: URLSessionClient(), store: store)
        let transport = RequestChainNetworkTransport(
            interceptorProvider: provider, endpointURL: ShopifyConfig.storeURL)
        return ApolloClient(networkTransport: transport, store: store)
    }()

    // MARK: - Brand

    private func makeFetchBrandsUseCase() -> FetchBrandsUseCaseProtocol {
        FetchBrandsUseCase(repository: makeHomeRepository())
    }

    func makeBrandViewModel() -> BrandViewModel {
        BrandViewModel(fetchBrandsUseCase: makeFetchBrandsUseCase())
    }
    // MARK: - Home
    private func makeHomeRepository() -> HomeRepositoryProtocol {
        MockHomeRepository()
    }
    private func makeFetchBannersUseCase() -> FetchBannersUseCaseProtocol {
        FetchBannersUseCase(repository: makeHomeRepository())
    }
    private func makeFetchLatestProductsUseCase()
        -> FetchLatestProductsUseCaseProtocol
    {
        FetchLatestProductsUseCase(repository: makeHomeRepository())
    }
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchBannersUseCase: makeFetchBannersUseCase(),
            fetchLatestProductsUseCase: makeFetchLatestProductsUseCase()
        )
    }
}
