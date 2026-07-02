//
//  ProductDetails.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

struct ProductDetails: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let vendor: String
    let productType: String
    let tags: [String]
    let availableForSale: Bool
    
    let minPrice: Double
    let maxPrice: Double
    let currencyCode: String
    let compareAtPrice: Double?
    
    let images: [ProductImage]
    let options: [ProductOption]
    let variants: [ProductDetailsVariant]
    
    let rating: Double
    let reviewsCount: Int
    
    var isFavorite: Bool = false
}

struct ProductImage: Hashable {
    let id: String
    let url: String
    let altText: String?
}

struct ProductOption: Hashable {
    let id: String
    let name: String
    let values: [String]
}

struct ProductDetailsVariant: Identifiable, Hashable {
    let id: String
    let title: String
    let availableForSale: Bool
    let quantityAvailable: Int?
    let price: Double
    let currencyCode: String
    let compareAtPrice: Double?
    let selectedOptions: [SelectedOption]
    let imageURL: String?
}

struct SelectedOption: Hashable {
    let name: String
    let value: String
}
