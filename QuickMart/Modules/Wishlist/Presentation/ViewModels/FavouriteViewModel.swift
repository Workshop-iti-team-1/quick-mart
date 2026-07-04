//
//  FavouriteViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//

import Combine
import Foundation

@MainActor
final class FavouriteViewModel: ObservableObject {
    static let shared = FavouriteViewModel(useCases: DIContainer.shared.makeFavoriteUseCases())

    @Published private(set) var favoriteIDs: Set<String> = []
    @Published private(set) var favorites: [FavoriteProduct] = []
    @Published var errorMessage: String?

    private let useCases: FavoriteUseCases
    private var cancellables = Set<AnyCancellable>()

    init(useCases: FavoriteUseCases) {
        self.useCases = useCases
        observeSessionChanges()
        loadFavorites()
    }

    /// Whenever the active user switches (login, logout, guest), the previous
    /// user's in-memory favorites are stale — reload from the newly-scoped store.
    private func observeSessionChanges() {
        SessionManager.shared.$currentState
            .removeDuplicates()
            .dropFirst() // skip the initial value already handled by loadFavorites() in init
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.favorites = []
                self?.favoriteIDs = []
                self?.loadFavorites()
            }
            .store(in: &cancellables)
    }

    func loadFavorites() {
        useCases.fetchFavorites()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion { self?.errorMessage = error.localizedDescription }
            } receiveValue: { [weak self] favorites in
                self?.favorites = favorites
                self?.favoriteIDs = Set(favorites.map { $0.id })
            }
            .store(in: &cancellables)
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteIDs.contains(id)
    }

    @discardableResult
    func toggle(_ product: ProductDetails) throws -> Bool {
        guard SessionManager.shared.currentState == .loggedIn else {
            throw FavoriteActionError.requiresLogin
        }
        if favoriteIDs.contains(product.id) {
            removeFavorite(id: product.id)
            return false
        } else {
            addFavorite(product)
            return true
        }
    }

    func addFavorite(_ product: ProductDetails) {
        favoriteIDs.insert(product.id) // optimistic
        useCases.addFavorite(product)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.favoriteIDs.remove(product.id)
                    self?.errorMessage = error.localizedDescription
                }
            }  receiveValue: { [weak self] in
                self?.loadFavorites()
            }
            
            .store(in: &cancellables)
    }

    func removeFavorite(id: String) {
        favoriteIDs.remove(id)
        useCases.removeFavorite(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.favoriteIDs.insert(id)
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] in
                self?.favorites.removeAll { $0.id == id }
            }
            .store(in: &cancellables)
    }

    func syncIfFavorite(_ product: ProductDetails) {
        guard favoriteIDs.contains(product.id) else { return }
        useCases.addFavorite(product)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func getCachedProduct(id: String) -> ProductDetails? {
        useCases.getCachedProduct(id: id)
    }
}


