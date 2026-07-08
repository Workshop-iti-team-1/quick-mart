//
//  CoreDataStack.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


// Data/CoreData/CoreDataStack.swift
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "QuickMart")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
