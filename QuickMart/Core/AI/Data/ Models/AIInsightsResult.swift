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
