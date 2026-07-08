//
//  AIComparisonResult.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  AIStructuredModels.swift
//  QuickMart
//
import Foundation

struct AIComparisonResult: Decodable {
    struct Point: Decodable {
        let productIndex: Int
        let strengths: [String]
        let bestFor: String
    }
    let points: [Point]
    let recommendedIndex: Int
    let recommendationReason: String
}



/// A resolved outfit piece — a REAL catalog product matched from searchQuery, not an AI guess.
struct OutfitProductSuggestion: Identifiable {
    let id: String
    let category: String
    let reason: String
    let product: ProductSearchItem
}



import Foundation

struct OutfitSuggestionItem: Decodable {
    let category: String     // "Top" | "Bottom" | "Shoes" | "Accessory" | "Outerwear"
    let searchQuery: String  // generic phrase run through real catalog search
    let reason: String
}
//
//  AIInsightsResult.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation


struct AIInsightsResult: Decodable {
    struct Insight: Decodable {
        let category: String // "spending" | "brand" | "category" | "suggestion" | "general"
        let title: String
        let text: String
    }
    let insights: [Insight]
}
//


import Foundation

struct AIOutfitResult: Decodable {
    struct Piece: Decodable {
        let category: String   // e.g. "Top", "Shoes", "Accessory"
        let itemName: String
        let reason: String
    }
    let pieces: [Piece]
    let styleNote: String
}


