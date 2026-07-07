//
//  AIInsightsResult.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

struct AIInsightsResult: Decodable {
    struct Insight: Decodable {
        let icon: String       // SF Symbol name, model picks from a short list we give it
        let title: String
        let description: String
    }
    let insights: [Insight]
    let favoriteCategory: String?
}
