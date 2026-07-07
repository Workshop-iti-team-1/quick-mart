//
//  AIOutfitResult.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
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
