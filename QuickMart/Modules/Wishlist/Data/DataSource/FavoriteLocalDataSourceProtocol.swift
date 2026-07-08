//
//  FavoriteLocalDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


// Data/DataSources/FavoriteLocalDataSourceProtocol.swift
import Combine
import Foundation

protocol FavoriteLocalDataSourceProtocol {
    func fetchAll(userId: String) -> AnyPublisher<[FavoriteProduct], Error>
    func save(_ product: ProductDetails, userId: String) -> AnyPublisher<Void, Error>
    func delete(id: String, userId: String) -> AnyPublisher<Void, Error>
    func fetchFullProduct(id: String, userId: String) -> ProductDetails?
}
