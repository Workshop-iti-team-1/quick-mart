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

