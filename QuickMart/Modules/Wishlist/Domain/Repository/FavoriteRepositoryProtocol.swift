//
//  FavoriteRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


// Domain/Repositories/FavoriteRepositoryProtocol.swift
import Combine

protocol FavoriteRepositoryProtocol {
    func fetchFavorites() -> AnyPublisher<[FavoriteProduct], Error>
    func addFavorite(_ product: ProductDetails) -> AnyPublisher<Void, Error>
    func removeFavorite(id: String) -> AnyPublisher<Void, Error>
    func getCachedProduct(id: String) -> ProductDetails?
}
