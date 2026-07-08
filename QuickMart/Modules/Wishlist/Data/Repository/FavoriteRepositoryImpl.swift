//
//  FavoriteRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


import Combine

final class FavoriteRepositoryImpl: FavoriteRepositoryProtocol {
    private let localDataSource: FavoriteLocalDataSourceProtocol
    private let sessionManager: SessionManager

    init(localDataSource: FavoriteLocalDataSourceProtocol, sessionManager: SessionManager = .shared) {
        self.localDataSource = localDataSource
        self.sessionManager = sessionManager
    }

    private var currentUserId: String { sessionManager.currentUserId }

    func fetchFavorites() -> AnyPublisher<[FavoriteProduct], Error> {
        localDataSource.fetchAll(userId: currentUserId)
    }
    func addFavorite(_ product: ProductDetails) -> AnyPublisher<Void, Error> {
        localDataSource.save(product, userId: currentUserId)
    }
    func removeFavorite(id: String) -> AnyPublisher<Void, Error> {
        localDataSource.delete(id: id, userId: currentUserId)
    }
    func getCachedProduct(id: String) -> ProductDetails? {
        localDataSource.fetchFullProduct(id: id, userId: currentUserId)
    }
}
