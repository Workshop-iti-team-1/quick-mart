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
           let provider = NetworkInterceptorProvider(client: URLSessionClient(), store: store)
           let transport = RequestChainNetworkTransport(
               interceptorProvider: provider, endpointURL: ShopifyConfig.storeURL)
           return ApolloClient(networkTransport: transport, store: store)
       }()

       // MARK: - Home Repository (shared)
       private lazy var homeRepository: HomeRepositoryProtocol = {
           HomeRepositoryImpl(remoteDataSource: HomeRemoteDataSource(client: graphQLClient))
       }()

    // MARK: - Home
    private func makeFetchBannersUseCase() -> FetchBannersUseCaseProtocol {
        FetchBannersUseCase(repository: homeRepository)
    }
    private func makeFetchLatestProductsUseCase() -> FetchLatestProductsUseCaseProtocol {
        FetchLatestProductsUseCase(repository: homeRepository)
    }
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchBannersUseCase: makeFetchBannersUseCase(),
            fetchLatestProductsUseCase: makeFetchLatestProductsUseCase()
        )
    }

    // MARK: - Brand
    private func makeFetchBrandsUseCase() -> FetchBrandsUseCaseProtocol {
        FetchBrandsUseCase(repository: homeRepository)
    }
    func makeBrandViewModel() -> BrandViewModel {
        BrandViewModel(fetchBrandsUseCase: makeFetchBrandsUseCase())
    }

    // MARK: - Home Category
    private func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: homeRepository)
    }
    func makeCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(fetchCategoriesUseCase: makeFetchCategoriesUseCase())
    }
    // MARK: - Cart
    private func makeRemoteCartDataSource() -> RemoteCartDataSource {
        RemoteCartDataSourceImpl(client: GraphQLClient(apollo: apolloClient))
    }
    
    private func makeCartRepository() -> CartRepository {
        CartRepositoryImpl(remoteDataSource: makeRemoteCartDataSource(), commonRemoteDataSource: makeCommonRemoteDataSource())
    }
    
    private func makeCartUseCases() -> CartUseCases {
        CartUseCasesImpl(repository: makeCartRepository())
    }
    
    func makeCartViewModel() -> CartViewModel {
        CartViewModel(useCases: makeCartUseCases())
    }
    
    // MARK: - Root
    func makeRootViewModel() -> RootViewModel {
        RootViewModel(cartUseCases: makeCartUseCases())
    }
    
    // MARK: - Common
    private func makeCommonRemoteDataSource() -> CommonRemoteDataSourceProtocol {
        CommonRemoteDataSource(client: GraphQLClient(apollo: apolloClient))
    }
    
    private func makeCommonRepository() -> CommonRepositoryProtocol {
        CommonRepositoryImpl(remoteDataSource: makeCommonRemoteDataSource())
    }
    
    private func makeAddToCartUseCase() -> AddToCartUseCaseProtocol {
        AddToCartUseCase(repository: makeCommonRepository())
    }
    
    // MARK: - Product Details
    private func makeGetProductDetailsUseCase() -> GetProductDetailsUseCaseProtocol {
        GetProductDetailsUseCase(repository: homeRepository)
    }
    
    func makeProductDetailsViewModel(productId: String) -> ProductDetailsViewModel {
        ProductDetailsViewModel(productId: productId, getProductDetailsUseCase: makeGetProductDetailsUseCase(), addToCartUseCase: makeAddToCartUseCase())
    }
}
