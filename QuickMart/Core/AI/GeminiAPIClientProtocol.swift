//
//  GeminiAPIClientProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  GeminiAPIClientProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

protocol GeminiAPIClientProtocol {
    func generate(prompt: String, imageData: Data?, model: String, maxTokens: Int) async throws -> String
}

// Default parameter so existing call-sites don't break
extension GeminiAPIClientProtocol {
    func generate(prompt: String, imageData: Data?, model: String) async throws -> String {
        try await generate(prompt: prompt, imageData: imageData, model: model, maxTokens: 1024)
    }
}

enum AIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case emptyResponse
    case decodingFailed
    case rateLimited

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid AI endpoint URL"
        case .requestFailed(let code):
            return "AI request failed (status \(code))"
        case .emptyResponse:
            return "AI returned no content"
        case .decodingFailed:
            return "Could not read AI response"
        case .rateLimited:
            return "AI is temporarily busy. Please try again in a minute."
        }
    }
}
