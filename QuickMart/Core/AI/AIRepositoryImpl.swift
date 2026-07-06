//
//  AIRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
//
//  AIRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation
import UIKit

final class AIRepositoryImpl: AIRepositoryProtocol {
    private let client: GeminiAPIClientProtocol
    init(client: GeminiAPIClientProtocol = GeminiAPIClient()) {
        self.client = client
    }

    // MARK: - Chat
    func sendChat(history: [AIMessage], newMessage: String, catalogContext: String) async throws -> String {
        // Only send last 6 messages to keep token usage low
        let recentHistory = history.suffix(6)
        let transcript = recentHistory
            .map { "\($0.role.rawValue): \($0.text)" }
            .joined(separator: "\n")

        let prompt = """
        You are QuickMart's shopping assistant. Be concise and friendly. \
        Only reference items from this catalog snippet if relevant:
        \(catalogContext)

        Conversation so far:
        \(transcript)
        user: \(newMessage)
        model:
        """
        return try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 700)
    }

    // MARK: - Compare
    func compareProducts(_ products: [ProductDetails]) async throws -> String {
        let details = products.enumerated().map { i, p in
            "Product \(i + 1): \(p.title) by \(p.vendor), price: \(p.minPrice) \(p.currencyCode), rating: \(p.rating) (\(p.reviewsCount) reviews), tags: \(p.tags.joined(separator: ", "))"
        }.joined(separator: "\n")

        let prompt = """
        Compare these products for a shopper. Give a short breakdown per product \
        (price, key strengths, who it's best for), then a one-line final recommendation.
        \(details)
        """
        return try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 1024)
    }

    // MARK: - Image Search
    func searchByImage(_ imageData: Data) async throws -> String {
        // Compress image before sending to drastically reduce token usage
        let compressed = Self.compressImageForAI(imageData) ?? imageData

        let prompt = """
        Identify the main product or clothing item in this image in 2-5 words, \
        suitable as a shop search query (e.g. "blue denim jacket"). Reply with only the phrase, nothing else.
        """
        // Only need ~30 tokens max for a 2-5 word response
        let result = try await client.generate(prompt: prompt, imageData: compressed, model: AIConfig.visionModel, maxTokens: 30)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Outfit
    func generateOutfit(for product: ProductDetails, catalogContext: String) async throws -> String {
        let prompt = """
        Suggest a complete outfit built around this item: \(product.title) (\(product.productType), \(product.tags.joined(separator: ", "))).
        Consider these items available in the catalog when possible:
        \(catalogContext)
        List 3-4 complementary pieces with a one-line reason each. Keep it short.
        """
        return try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 800)
    }

    // MARK: - Insights
    func generateInsights(orders: [OrderEntity]) async throws -> String {
        guard !orders.isEmpty else { return "No order history yet — start shopping to see insights here!" }

        // Cap at 10 most recent orders to save tokens
        let recentOrders = orders.suffix(10)
        let history = recentOrders.map { order in
            let items = order.lineItems.map(\.title).joined(separator: ", ")
            return "\(order.processedAt.formatted(date: .abbreviated, time: .omitted)): \(items) — total \(order.currentTotalPrice) \(order.currencyCode)"
        }.joined(separator: "\n")

        let prompt = """
        Analyze this shopper's order history and give 3-4 short, friendly insights \
        (spending patterns, categories/vendors they favor, one gentle suggestion). Keep each point to one sentence.
        Order history:
        \(history)
        """
        return try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 1000)
    }

    // MARK: - Image Compression Helper
    /// Resizes the image to max 512px on its longest side and compresses to 60% JPEG quality.
    /// This can reduce a 2MB photo → ~30-50KB, saving massive tokens on the base64 payload.
    private static func compressImageForAI(_ data: Data, maxDimension: CGFloat = 512) -> Data? {
        guard let image = UIImage(data: data) else { return nil }

        let longest = max(image.size.width, image.size.height)
        let scale = min(maxDimension / longest, 1.0) // never upscale

        if scale >= 1.0 {
            // Already small enough, just re-compress
            return image.jpegData(compressionQuality: 0.6)
        }

        let newSize = CGSize(
            width: image.size.width * scale,
            height: image.size.height * scale
        )

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.6)
    }
}
