//
//  AIRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

//
//  AIRepositoryProtocol.swift
//  QuickMart
//
import Foundation

protocol AIRepositoryProtocol {
    func sendChat(history: [AIMessage], newMessage: String, catalogContext: String) async throws -> String
    func compareProducts(_ products: [ProductDetails]) async throws -> String
    func searchByImage(_ imageData: Data) async throws -> String
    func generateOutfitPlan(for product: ProductDetails) async throws -> [OutfitSuggestionItem]
    func generateInsights(cart: Cart?, orders: [OrderEntity]) async throws -> AIInsightsResult
}

