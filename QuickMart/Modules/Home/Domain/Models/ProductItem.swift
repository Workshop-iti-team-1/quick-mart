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
}
