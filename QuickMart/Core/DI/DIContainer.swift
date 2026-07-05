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

    private(set) lazy var restClient: RestClientProtocol = RestClient()

    let sessionManager = SessionManager.shared
    // MARK: - Home Repository (shared)
  
    private lazy var homeRepository: HomeRepositoryProtocol = {
        HomeRepositoryImpl(
            remoteDataSource: HomeRemoteDataSource(client: graphQLClient),
            discountDataSource: DiscountDataSource()
        )
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
    private func makeCommonRemoteDataSource() -> CommonCartRemoteDataSourceProtocol {
        CommonCartRemoteDataSource(client: GraphQLClient(apollo: apolloClient))
    }
    
    private func makeCommonRepository() -> CommonCartRepositoryProtocol {
        CommonCartRepositoryImpl(remoteDataSource: makeCommonRemoteDataSource())
    }

    private func makeAddToCartUseCase() -> AddToCartUseCaseProtocol {
        AddToCartUseCase(repository: makeCommonRepository())
    }

    // MARK: - Product Details
    private func makeGetProductDetailsUseCase() -> GetProductDetailsUseCaseProtocol {
        GetProductDetailsUseCase(repository: homeRepository)
    }

    // Single source of truth for building ProductDetailsViewModel.
    // preloadedProduct defaults to nil so all existing call sites (router.push(.productDetail(id)))
    // keep working unchanged; only the Wishlist offline-detail path passes a cached product.
    func makeProductDetailsViewModel(productId: String, preloadedProduct: ProductDetails? = nil) -> ProductDetailsViewModel {
        ProductDetailsViewModel(
            productId: productId,
            getProductDetailsUseCase: makeGetProductDetailsUseCase(),
            addToCartUseCase: makeAddToCartUseCase(),
            preloadedProduct: preloadedProduct
        )
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
    private var fetchPredictiveSearchUseCase: FetchPredictiveSearchUseCaseProtocol {
        FetchPredictiveSearchUseCase(repository: searchRepository)
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
            fetchPredictiveSearchUseCase: fetchPredictiveSearchUseCase,
            repository: searchRepository
        )
    }

    // MARK: - Address

    private func makeAddressRemoteDataSource() -> AddressRemoteDataSourceProtocol {
        AddressRemoteDataSourceImpl(client: GraphQLClient(apollo: apolloClient))
    }
    private func makeAddressRepository() -> AddressRepositoryProtocol {
        AddressRepositoryImpl(remoteDataSource: makeAddressRemoteDataSource())
    }
    func makeAddressUseCases() -> AddressUseCases {
        AddressUseCasesImpl(repository: makeAddressRepository())
    }

    // MARK: - Country/City reference data

    private lazy var countryRemoteDataSource: CountryRemoteDataSourceProtocol = CountryRemoteDataSourceImpl()
    private lazy var countryRepository: CountryRepositoryProtocol = CountryRepositoryImpl(remoteDataSource: countryRemoteDataSource)
    private func makeFetchCountriesUseCase() -> FetchCountriesUseCaseProtocol {
        FetchCountriesUseCase(repository: countryRepository)
    }
    private(set) lazy var countryDataProvider: CountryDataProvider = CountryDataProvider(
        fetchCountriesUseCase: makeFetchCountriesUseCase()
    )

    // MARK: - Favorites

    private lazy var favoriteLocalDataSource: FavoriteLocalDataSourceProtocol =
        FavoriteLocalDataSourceImpl(context: CoreDataStack.shared.context)
    

    func makeFavoriteUseCases() -> FavoriteUseCases {
        FavoriteUseCasesImpl(repository: favoriteRepository)
    }
    private lazy var favoriteRepository: FavoriteRepositoryProtocol =
        FavoriteRepositoryImpl(localDataSource: favoriteLocalDataSource)
}
