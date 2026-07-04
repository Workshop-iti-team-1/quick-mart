//
//  FavoriteLocalDataSourceImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


import CoreData
import Combine
import Foundation

final class FavoriteLocalDataSourceImpl: FavoriteLocalDataSourceProtocol {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }

    func fetchAll(userId: String) -> AnyPublisher<[FavoriteProduct], Error> {
        Future { [context] promise in
            context.perform {
                do {
                    let request = FavouriteProductEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "userId == %@", userId)
                    request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
                    let entities = try context.fetch(request)
                    promise(.success(entities.map { $0.toEntity() }))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func save(_ product: ProductDetails, userId: String) -> AnyPublisher<Void, Error> {
        Future { [context] promise in
            context.perform {
                do {
                    let request = FavouriteProductEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@ AND userId == %@", product.id, userId)
                    request.fetchLimit = 1
                    let existing = try context.fetch(request).first
                    let entity = existing ?? FavouriteProductEntity(context: context)
                    try entity.update(from: product, userId: userId, isNew: existing == nil)
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func delete(id: String, userId: String) -> AnyPublisher<Void, Error> {
        Future { [context] promise in
            context.perform {
                do {
                    let request = FavouriteProductEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "id == %@ AND userId == %@", id, userId)
                    try context.fetch(request).forEach { context.delete($0) }
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchFullProduct(id: String, userId: String) -> ProductDetails? {
        let request = FavouriteProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND userId == %@", id, userId)
        request.fetchLimit = 1
        guard let entity = try? context.fetch(request).first else { return nil }
        return entity.toFullProductDetails()
    }
}
