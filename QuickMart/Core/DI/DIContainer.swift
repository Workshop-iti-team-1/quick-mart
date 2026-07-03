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

    // MARK: - Home Repository (shared)
    private lazy var homeRepository: HomeRepositoryProtocol = {
        HomeRepositoryImpl(
            remoteDataSource: HomeRemoteDataSource(client: graphQLClient))
    }()

    // MARK: - Home
    private func makeFetchBannersUseCase() -> FetchBannersUseCaseProtocol {
        FetchBannersUseCase(repository: homeRepository)
    }
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            fetchBannersUseCase: makeFetchBannersUseCase()
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
    private func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol
    {
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

    // MARK: - Private Assembly

    private var searchRemoteDataSource: SearchRemoteDataSourceProtocol {
        SearchRemoteDataSource(client: graphQLClient)
    }

    private var searchRepository: SearchRepositoryProtocol {
        ShopifySearchRepository(remoteDataSource: searchRemoteDataSource)
        // Swap for MockSearchRepository() during UI testing or Previews
    }

    private var searchProductsUseCase: SearchProductsUseCaseProtocol {
        SearchProductsUseCase(repository: searchRepository)
    }

    private var fetchSubCategoriesUseCase: FetchSubCategoriesUseCaseProtocol {
        FetchSubCategoriesUseCase(repository: searchRepository)
    }

    // MARK: - Public Factory

    @MainActor
        func makeSearchViewModel(initialFilters: SearchFilters = SearchFilters()) -> SearchViewModel {
            SearchViewModel(
                initialFilters: initialFilters,
                searchProductsUseCase: searchProductsUseCase,
                fetchSubCategoriesUseCase: fetchSubCategoriesUseCase,
                fetchCategoriesUseCase: makeFetchCategoriesUseCase(),
                fetchBrandsUseCase: makeFetchBrandsUseCase(),
                repository: searchRepository
            )
        }
    
    
    private func makeAddressRemoteDataSource() -> AddressRemoteDataSourceProtocol {
        AddressRemoteDataSourceImpl(client: GraphQLClient(apollo: apolloClient))
    }
    private func makeAddressRepository() -> AddressRepositoryProtocol {
        AddressRepositoryImpl(remoteDataSource: makeAddressRemoteDataSource())
    }
    func makeAddressUseCases() -> AddressUseCases {
        AddressUseCasesImpl(repository: makeAddressRepository())
    }
    
    private lazy var countryRemoteDataSource: CountryRemoteDataSourceProtocol = CountryRemoteDataSourceImpl()
    private lazy var countryRepository: CountryRepositoryProtocol = CountryRepositoryImpl(remoteDataSource: countryRemoteDataSource)
    private func makeFetchCountriesUseCase() -> FetchCountriesUseCaseProtocol {
        FetchCountriesUseCase(repository: countryRepository)
    }
    private(set) lazy var countryDataProvider: CountryDataProvider = CountryDataProvider(
        fetchCountriesUseCase: makeFetchCountriesUseCase()
    )
}
