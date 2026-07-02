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

    // MARK: - Home Repository (single instance shared across home use cases)
    private func makeHomeRepository() -> HomeRepositoryProtocol {
        MockHomeRepository()
    }

    // MARK: - Home
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

    // MARK: - Brand
    private func makeFetchBrandsUseCase() -> FetchBrandsUseCaseProtocol {
        FetchBrandsUseCase(repository: makeHomeRepository())
    }
    func makeBrandViewModel() -> BrandViewModel {
        BrandViewModel(fetchBrandsUseCase: makeFetchBrandsUseCase())
    }

    // MARK: -  Category
    private func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: makeHomeRepository())
    }
    func makeCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(fetchCategoriesUseCase: makeFetchCategoriesUseCase())
    }

    // MARK: - Private Assembly

    private var searchRepository: SearchRepositoryProtocol {
        MockSearchRepository()
        // Future: ShopifySearchRepository(client: rawGraphQLClient)
    }

    private var searchProductsUseCase: SearchProductsUseCaseProtocol {
        SearchProductsUseCase(repository: searchRepository)
    }

    private var fetchSubCategoriesUseCase: FetchSubCategoriesUseCaseProtocol {
        FetchSubCategoriesUseCase(repository: searchRepository)
    }

    // MARK: - Public Factory
    @MainActor
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            searchProductsUseCase: searchProductsUseCase,
            fetchSubCategoriesUseCase: fetchSubCategoriesUseCase,
            fetchCategoriesUseCase: makeFetchCategoriesUseCase(), // reused from DIContainer
            fetchBrandsUseCase: makeFetchBrandsUseCase(),         // reused from DIContainer
            repository: searchRepository
        )
    }
}
