//
//  OutfitProductSuggestion.swift
//  QuickMart
//
//  Created by Alaa Ayman on 07/07/2026.
//
import Foundation

/// A resolved outfit piece — a REAL catalog product matched from searchQuery, not an AI guess.
struct OutfitProductSuggestion: Identifiable {
    let id: String
    let category: String
    let reason: String
    let product: ProductSearchItem
}
