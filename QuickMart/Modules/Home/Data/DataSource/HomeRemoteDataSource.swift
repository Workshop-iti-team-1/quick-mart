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
}
