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
    func generateOutfit(for product: ProductDetails, catalogContext: String) async throws -> String
    func generateInsights(orders: [OrderEntity]) async throws -> String
}
