//
//  FavouriteProductEntity+CoreDataProperties.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.

import Foundation
import CoreData

extension FavouriteProductEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteProductEntity> {
        NSFetchRequest<FavouriteProductEntity>(entityName: "FavouriteProductEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var userId: String  
    @NSManaged public var title: String
    @NSManaged public var imageURL: String?
    @NSManaged public var price: Double
    @NSManaged public var compareAtPrice: NSNumber?
    @NSManaged public var currencyCode: String
    @NSManaged public var rating: Double
    @NSManaged public var reviewsCount: Int32
    @NSManaged public var dateAdded: Date
    @NSManaged public var productData: Data
}

extension FavouriteProductEntity: Identifiable {}
