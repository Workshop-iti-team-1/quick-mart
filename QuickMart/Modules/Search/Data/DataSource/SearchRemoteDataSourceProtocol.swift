//
//  SearchRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation
import Combine

protocol SearchRemoteDataSourceProtocol {

    /// Global product search with sort and cursor-based pagination.
    /// Returns a Combine publisher — consistent with HomeRemoteDataSourceProtocol.
    func searchProducts(
        query: String,
        first: Int,
        after: String?,
        sortKey: String?,
        reverse: Bool
    ) -> AnyPublisher<SearchResultPage, Error>

    /// Fetches all distinct product types (Sub-Categories).
    /// Returns a Combine publisher — consistent with HomeRemoteDataSourceProtocol.
    func fetchProductTypes(first: Int) -> AnyPublisher<[String], Error>
}
