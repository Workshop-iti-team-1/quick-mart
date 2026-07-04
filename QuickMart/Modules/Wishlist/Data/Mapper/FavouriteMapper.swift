//
//  FavouriteMapper.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


import Foundation

extension FavouriteProductEntity {
    func toEntity() -> FavoriteProduct {
        FavoriteProduct(
            id: id, title: title, imageURL: imageURL, price: price,
            compareAtPrice: compareAtPrice?.doubleValue, currencyCode: currencyCode,
            rating: rating, reviewsCount: Int(reviewsCount), dateAdded: dateAdded
        )
    }

    func toFullProductDetails() -> ProductDetails? {
        try? JSONDecoder().decode(ProductDetails.self, from: productData)
    }

    /// Upserts this entity's fields from a ProductDetails, scoped to a specific user.
    func update(from product: ProductDetails, userId: String, isNew: Bool) throws {
        id = product.id
        self.userId = userId
        title = product.title
        imageURL = product.images.first?.url
        price = product.minPrice
        compareAtPrice = product.compareAtPrice.map { NSNumber(value: $0) }
        currencyCode = product.currencyCode
        rating = product.rating
        reviewsCount = Int32(product.reviewsCount)
        if isNew { dateAdded = Date() }
        productData = try JSONEncoder().encode(product)
    }
}
