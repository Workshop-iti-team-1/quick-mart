//
//  FavoriteProduct.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


// Domain/Models/FavoriteProduct.swift
import Foundation

/// Lightweight model for the Wishlist list screen — decoding the full
/// productData blob for every row would be wasteful, so this mirrors
/// only the flat Core Data columns.
struct FavoriteProduct: Identifiable, Hashable {
    let id: String
    let title: String
    let imageURL: String?
    let price: Double
    let compareAtPrice: Double?
    let currencyCode: String
    let rating: Double
    let reviewsCount: Int
    let dateAdded: Date
}

enum FavoriteActionError: LocalizedError {
    case requiresLogin
    var errorDescription: String? {
        switch self {
        case .requiresLogin: return "Please log in to save items to your wishlist."
        }
    }
}