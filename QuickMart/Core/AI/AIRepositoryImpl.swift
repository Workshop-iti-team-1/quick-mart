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
import Foundation
import UIKit

final class AIRepositoryImpl: AIRepositoryProtocol {
    private let client: GeminiAPIClientProtocol
    init(client: GeminiAPIClientProtocol = GeminiAPIClient()) {
        self.client = client
    }

    // MARK: - Chat
    func sendChat(history: [AIMessage], newMessage: String, catalogContext: String) async throws -> String {
        let recentHistory = history.suffix(6)
        let transcript = recentHistory.map { "\($0.role.rawValue): \($0.text)" }.joined(separator: "\n")
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
        return try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 1500)
    }

    // MARK: - Image Search
    func searchByImage(_ imageData: Data) async throws -> String {
        let compressed = Self.compressImageForAI(imageData) ?? imageData
        let prompt = """
        Identify the main product or clothing item in this image in 2-5 words, \
        suitable as a shop search query. Reply with only the phrase, nothing else.
        """
        let result = try await client.generate(prompt: prompt, imageData: compressed, model: AIConfig.visionModel, maxTokens: 60)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    // MARK: - Outfit
    func generateOutfitPlan(for product: ProductDetails) async throws -> [OutfitSuggestionItem] {
        let prompt = """
        Suggest a complete outfit built around this item: \(product.title) by \(product.vendor) \
        (\(product.productType), tags: \(product.tags.joined(separator: ", "))).
        Return exactly 3 items. searchQuery must be generic (e.g. "black slim jeans", "white sneakers"), \
        NOT a specific brand name, so it can be matched against a general clothing catalog.
        """
        let schema: [String: Any] = [
            "type": "ARRAY",
            "items": [
                "type": "OBJECT",
                "properties": [
                    "category": ["type": "STRING", "enum": ["Top", "Bottom", "Shoes", "Accessory", "Outerwear"]],
                    "searchQuery": ["type": "STRING"],
                    "reason": ["type": "STRING"]
                ],
                "required": ["category", "searchQuery", "reason"]
            ]
        ]
        let text = try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 2000, jsonMode: true, responseSchema: schema)
        return try Self.decodeJSON([OutfitSuggestionItem].self, from: text)
    }

    // MARK: - Insights
    func generateInsights(cart: Cart?, orders: [OrderEntity]) async throws -> AIInsightsResult {
        guard cart != nil || !orders.isEmpty else {
            return AIInsightsResult(insights: [
                .init(category: "general", title: "No activity yet", text: "Start shopping to see personalized insights here!")
            ])
        }

        var contextParts: [String] = []
        if let cart, !cart.lines.isEmpty {
            let cartLines = cart.lines.map { line in
                "\(line.quantity)x \(line.merchandise.productTitle) (\(line.merchandise.productVendor)) - \(line.cost.totalAmount) \(line.cost.currencyCode)"
            }.joined(separator: "\n")
            contextParts.append("Current cart (\(cart.totalQuantity) items, total \(cart.cost.totalAmount) \(cart.cost.currencyCode)):\n\(cartLines)")
        }
        if !orders.isEmpty {
            let recentOrders = orders.suffix(10)
            let history = recentOrders.map { order in
                let items = order.lineItems.map(\.title).joined(separator: ", ")
                return "\(order.processedAt.formatted(date: .abbreviated, time: .omitted)): \(items) — total \(order.currentTotalPrice) \(order.currencyCode)"
            }.joined(separator: "\n")
            contextParts.append("Order history:\n\(history)")
        }
        let combinedContext = contextParts.joined(separator: "\n\n")

        let prompt = """
        Analyze this shopper's current cart and order history below. \
        Give 3-4 insights: spending patterns, favored brands/categories, and one gentle suggestion — \
        base them on what's actually in the data below, don't invent anything.
        \(combinedContext)
        """
        let schema: [String: Any] = [
            "type": "OBJECT",
            "properties": [
                "insights": [
                    "type": "ARRAY",
                    "items": [
                        "type": "OBJECT",
                        "properties": [
                            "category": ["type": "STRING", "enum": ["spending", "brand", "category", "suggestion", "general"]],
                            "title": ["type": "STRING"],
                            "text": ["type": "STRING"]
                        ],
                        "required": ["category", "title", "text"]
                    ]
                ]
            ],
            "required": ["insights"]
        ]
        let text = try await client.generate(prompt: prompt, imageData: nil, model: AIConfig.textModel, maxTokens: 2000, jsonMode: true, responseSchema: schema)
        return try Self.decodeJSON(AIInsightsResult.self, from: text)
    }

    // MARK: - JSON Helper (with the debug logging that actually runs now)
    private static func decodeJSON<T: Decodable>(_ type: T.Type, from text: String) throws -> T {
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("```") {
            cleaned = cleaned.replacingOccurrences(of: "```json", with: "")
            cleaned = cleaned.replacingOccurrences(of: "```", with: "")
            cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guard let data = cleaned.data(using: .utf8) else { throw AIError.decodingFailed }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("⚠️ JSON decode failed for \(T.self):\n\(cleaned)\nUnderlying error: \(error)")
            #endif
            throw AIError.decodingFailed
        }
    }

    // MARK: - Image Compression
    private static func compressImageForAI(_ data: Data, maxDimension: CGFloat = 512) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let longest = max(image.size.width, image.size.height)
        let scale = min(maxDimension / longest, 1.0)
        if scale >= 1.0 { return image.jpegData(compressionQuality: 0.6) }
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
        return resized.jpegData(compressionQuality: 0.6)
    }
}

