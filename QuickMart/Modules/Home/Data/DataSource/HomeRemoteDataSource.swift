//
//  HomeRemoteDataSource.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//
import Foundation
import Combine

final class HomeRemoteDataSource: HomeRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol

    init(client: ShopifyGraphQLClientProtocol) {
        self.client = client
    }

    func fetchCollections(first: Int) -> AnyPublisher<[CollectionModel], Error> {
        Future { promise in
            Task {
                do {
                    let query = ShopifyAPI.GetCollectionsQuery(
                        first: first,
                        after: .none
                    )
                    let response = try await self.client.performQuery(query: query)
                    let dtos = response.collections.edges.map { $0.node.toDTO() }
                    promise(.success(dtos))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func getProduct(id: String) async throws -> ShopifyAPI.GetProductQuery.Data.Product {
        let query = ShopifyAPI.GetProductQuery(id: id)
        let response = try await client.performQuery(query: query)
        guard let product = response.product else {
            throw NSError(domain: "ProductNotFound", code: 404, userInfo: nil)
        }
        return product
    }
}
