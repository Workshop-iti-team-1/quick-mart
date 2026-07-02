//
//  ProductItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import Foundation

struct ProductItem: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let imageName: String
    let isSystemImage: Bool
    let colorNames: [String]   
    let colorCount: Int
    var isFavorite: Bool = false
    
    // New fields for Product Details
    var description: String = ""
    var rating: Double = 0.0
    var reviewsCount: Int = 0
    var sizes: [String] = []
    var variantId: String = ""
}
