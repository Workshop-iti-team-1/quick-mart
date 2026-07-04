//
//  FavoriteUseCases.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


// Domain/UseCases/FavoriteUseCases.swift
import Combine

protocol FavoriteUseCases {
    func fetchFavorites() -> AnyPublisher<[FavoriteProduct], Error>
    func addFavorite(_ product: ProductDetails) -> AnyPublisher<Void, Error>
    func removeFavorite(id: String) -> AnyPublisher<Void, Error>
    func getCachedProduct(id: String) -> ProductDetails?
}

struct FavoriteUseCasesImpl: FavoriteUseCases {
    let repository: FavoriteRepositoryProtocol

    func fetchFavorites() -> AnyPublisher<[FavoriteProduct], Error> {
        repository.fetchFavorites()
    }
    func addFavorite(_ product: ProductDetails) -> AnyPublisher<Void, Error> {
        repository.addFavorite(product)
    }
    func removeFavorite(id: String) -> AnyPublisher<Void, Error> {
        repository.removeFavorite(id: id)
    }
    func getCachedProduct(id: String) -> ProductDetails? {
        repository.getCachedProduct(id: id)
    }
}