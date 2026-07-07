//
//  GeminiAPIClientProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation
protocol GeminiAPIClientProtocol {
    func generate(prompt: String, imageData: Data?, model: String, maxTokens: Int, jsonMode: Bool, responseSchema: [String: Any]?) async throws -> String
}

extension GeminiAPIClientProtocol {
    func generate(prompt: String, imageData: Data?, model: String) async throws -> String {
        try await generate(prompt: prompt, imageData: imageData, model: model, maxTokens: 1024, jsonMode: false, responseSchema: nil)
    }
    func generate(prompt: String, imageData: Data?, model: String, maxTokens: Int) async throws -> String {
        try await generate(prompt: prompt, imageData: imageData, model: model, maxTokens: maxTokens, jsonMode: false, responseSchema: nil)
    }
    func generate(prompt: String, imageData: Data?, model: String, maxTokens: Int, jsonMode: Bool) async throws -> String {
        try await generate(prompt: prompt, imageData: imageData, model: model, maxTokens: maxTokens, jsonMode: jsonMode, responseSchema: nil)
    }
}
enum AIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case emptyResponse
    case decodingFailed
    case rateLimited
    case truncated   // ← new

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid AI endpoint URL"
        case .requestFailed(let code): return "AI request failed (status \(code))"
        case .emptyResponse: return "AI returned no content"
        case .decodingFailed: return "Could not read AI response"
        case .rateLimited: return "AI is temporarily busy. Please try again in a minute."
        case .truncated: return "AI response was cut off — try again"
        }
    }
}

