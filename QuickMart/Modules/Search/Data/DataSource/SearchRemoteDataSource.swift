//
//  SearchRemoteDataSource.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//
// Features/Search/Data/DataSource/SearchRemoteDataSource.swift

import Foundation
import Combine
import ApolloAPI

final class SearchRemoteDataSource: SearchRemoteDataSourceProtocol {

    // MARK: - Dependency

    private let client: ShopifyGraphQLClientProtocol

    // MARK: - Init

    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }

    // MARK: - Search Products

    func searchProducts(
        query: String,
        first: Int,
        after: String?,
        sortKey: String?,
        reverse: Bool
    ) -> AnyPublisher<SearchResultPage, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let mappedSortKey: GraphQLNullable<GraphQLEnum<ShopifyAPI.SearchSortKeys>>
                    if let sk = sortKey,
                       let key = ShopifyAPI.SearchSortKeys(rawValue: sk) {
                        mappedSortKey = .some(GraphQLEnum(key))
                    } else {
                        mappedSortKey = .none
                    }

                    let mappedAfter: GraphQLNullable<String> = after.map { .some($0) } ?? .none
                    let mappedReverse: GraphQLNullable<Bool> = reverse ? .some(true) : .none

                    let apolloQuery = ShopifyAPI.SearchProductsQuery(
                        query: query,
                        first: first,
                        after: mappedAfter,
                        sortKey: mappedSortKey,
                        reverse: mappedReverse
                    )

                    let response = try await self.client.performQuery(query: apolloQuery)
                    let page = Self.mapSearchPage(response.search)
                    promise(.success(page))

                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Fetch Product Types

    func fetchProductTypes(first: Int) -> AnyPublisher<[String], Error> {
        Future { [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let apolloQuery = ShopifyAPI.FetchProductTypesQuery(first: first)
                    let response = try await self.client.performQuery(query: apolloQuery)
                    let types = response.productTypes.edges
                        .map(\.node)
                        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                    promise(.success(types))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Predictive Search

    func fetchPredictiveSuggestions(
        query: String
    ) -> AnyPublisher<PredictiveSearchResultDTO, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let apolloQuery = ShopifyAPI.PredictiveSearchQuery(query: query)
                    let response = try await self.client.performQuery(query: apolloQuery)
                    guard let predictiveSearch = response.predictiveSearch else {
                        promise(.success(
                            PredictiveSearchResultDTO(products: [], collections: [])
                        ))
                        return
                    }
                    let dto = Self.mapPredictive(predictiveSearch)
                    promise(.success(dto))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Search Page Mapping

    private static func mapSearchPage(
        _ search: ShopifyAPI.SearchProductsQuery.Data.Search
    ) -> SearchResultPage {
        let nodes = search.edges.compactMap { edge -> SearchProductNode? in
            guard let product = edge.node.asProduct else { return nil }
            return mapSearchProduct(product)
        }
        return SearchResultPage(
            products: nodes,
            hasNextPage: search.pageInfo.hasNextPage,
            endCursor: search.pageInfo.endCursor,
            totalCount: search.totalCount
        )
    }

    private static func mapSearchProduct(
        _ product: ShopifyAPI.SearchProductsQuery.Data.Search.Edge.Node.AsProduct
    ) -> SearchProductNode {
        let minPrice  = Double(product.priceRange.minVariantPrice.amount) ?? 0.0
        let maxPrice  = Double(product.priceRange.maxVariantPrice.amount) ?? 0.0
        let compareAt = product.compareAtPriceRange.minVariantPrice.amount
            .flatMap { Double(String(describing: $0)) }
        let currencyCode   = product.priceRange.minVariantPrice.currencyCode.value?.rawValue ?? ""
        let imageNode      = product.images.edges.first?.node
        let collections    = product.collections.edges.map(\.node.handle)
        let firstVariantID = product.variants.edges.first?.node.id

        return SearchProductNode(
            id: product.id,
            title: product.title,
            vendor: product.vendor,
            productType: product.productType,
            availableForSale: product.availableForSale,
            minPrice: minPrice,
            maxPrice: maxPrice,
            compareAtPrice: compareAt,
            currencyCode: currencyCode,
            imageURL: imageNode?.url,
            imageAltText: imageNode?.altText ?? nil,
            collectionHandles: collections,
            firstVariantID: firstVariantID
        )
    }

    // MARK: - Predictive Mapping

    private static func mapPredictive(
        _ data: ShopifyAPI.PredictiveSearchQuery.Data.PredictiveSearch
    ) -> PredictiveSearchResultDTO {

        let products = data.products.map { product -> PredictiveProductDTO in
            let amount = Double(product.priceRange.minVariantPrice.amount) ?? 0.0
            let currency = product.priceRange.minVariantPrice.currencyCode.value?.rawValue ?? ""
            let imageNode = product.images.edges.first?.node
            return PredictiveProductDTO(
                id: product.id,
                title: product.title,
                vendor: product.vendor,
                minPrice: amount,
                currencyCode: currency,
                imageURL: imageNode?.url,
                imageAltText: imageNode?.altText ?? nil
            )
        }

        let collections = data.collections.map { collection -> PredictiveCollectionDTO in
            PredictiveCollectionDTO(
                id: collection.id,
                title: collection.title,
                handle: collection.handle,
                imageURL: collection.image?.url,
                imageAltText: collection.image?.altText ?? nil
            )
        }

        return PredictiveSearchResultDTO(
            products: products,
            collections: collections
        )
    }
}
