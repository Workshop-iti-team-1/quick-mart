//
//  OutfitSuggestionItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 07/07/2026.
//



import Foundation

struct OutfitSuggestionItem: Decodable {
    let category: String     // "Top" | "Bottom" | "Shoes" | "Accessory" | "Outerwear"
    let searchQuery: String  // generic phrase run through real catalog search
    let reason: String
}

