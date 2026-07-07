//
//  GeminiAPIClient.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.

//
//  GeminiAPIClient.swift
//  QuickMart
//
import Foundation

final class GeminiAPIClient: GeminiAPIClientProtocol {
    private let session: URLSession
    private var lastRequestTime: Date = .distantPast
    private let minRequestInterval: TimeInterval = 4
    private let lock = NSLock()

    // MARK: - Key Rotation
    private var currentKeyIndex = 0
    private let keyLock = NSLock()

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func currentAPIKey() -> String {
        keyLock.lock()
        defer { keyLock.unlock() }
        return AIConfig.apiKeys[currentKeyIndex]
    }

    /// Moves to the next key in the pool. Called when the current key's project hits 429.
    private func rotateToNextKey() {
        keyLock.lock()
        currentKeyIndex = (currentKeyIndex + 1) % AIConfig.apiKeys.count
        keyLock.unlock()
        #if DEBUG
        print("🔄 Rotated to Gemini API key index \(currentKeyIndex)")
        #endif
    }

    // GeminiAPIClient.generate
    func generate(prompt: String, imageData: Data?, model: String, maxTokens: Int = 1024, jsonMode: Bool = false, responseSchema: [String: Any]? = nil) async throws -> String {
        try await throttleIfNeeded()
        return try await executeWithRotation(
            prompt: prompt, imageData: imageData, model: model,
            maxTokens: maxTokens, jsonMode: jsonMode, responseSchema: responseSchema,
            attemptsRemaining: min(2, AIConfig.apiKeys.count)
        )
    }

    // MARK: - Throttling
    private func throttleIfNeeded() async throws {
        let waitTime: TimeInterval
        lock.lock()
        let elapsed = Date().timeIntervalSince(lastRequestTime)
        waitTime = elapsed < minRequestInterval ? minRequestInterval - elapsed : 0
        lastRequestTime = Date().addingTimeInterval(max(waitTime, 0))
        lock.unlock()
        if waitTime > 0 {
            try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
        }
    }

    // MARK: - Request Builder
    private func buildRequest(prompt: String, imageData: Data?, model: String, maxTokens: Int, jsonMode: Bool, responseSchema: [String: Any]?, apiKey: String) throws -> URLRequest {
        guard let url = URL(string: "\(AIConfig.baseURL)/\(model):generateContent") else {
            throw AIError.invalidURL
        }

        var parts: [[String: Any]] = [["text": prompt]]
        if let imageData {
            parts.append(["inline_data": ["mime_type": "image/jpeg", "data": imageData.base64EncodedString()]])
        }

        var generationConfig: [String: Any] = [
            "temperature": 0.7,
            "maxOutputTokens": maxTokens
        ]
        if jsonMode {
            generationConfig["responseMimeType"] = "application/json"
            generationConfig["thinkingConfig"] = ["thinkingBudget": 0]
            if let responseSchema {
                generationConfig["responseSchema"] = responseSchema
            }
        }

        let body: [String: Any] = [
            "contents": [["parts": parts]],
            "generationConfig": generationConfig
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }

    // MARK: - Execute with key rotation + single 429 retry per key
    private func executeWithRotation(
        prompt: String, imageData: Data?, model: String,
        maxTokens: Int, jsonMode: Bool, responseSchema: [String: Any]?,
        attemptsRemaining: Int
    ) async throws -> String {
        let apiKey = currentAPIKey()
        let request = try buildRequest(
            prompt: prompt, imageData: imageData, model: model,
            maxTokens: maxTokens, jsonMode: jsonMode, responseSchema: responseSchema, apiKey: apiKey
        )

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }

        if http.statusCode == 429 {
            if attemptsRemaining > 1 {
                // Try the next project's key immediately — no need to wait if it's a fresh quota pool
                rotateToNextKey()
                return try await executeWithRotation(
                    prompt: prompt, imageData: imageData, model: model,
                    maxTokens: maxTokens, jsonMode: jsonMode, responseSchema: responseSchema,
                    attemptsRemaining: attemptsRemaining - 1
                )
            } else {
                // Every key exhausted — wait once, then give up cleanly
                try await Task.sleep(nanoseconds: 10_000_000_000)
                let (retryData, retryResponse) = try await session.data(for: request)
                guard let retryHTTP = retryResponse as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                if retryHTTP.statusCode == 429 { throw AIError.rateLimited }
                guard (200...299).contains(retryHTTP.statusCode) else { throw AIError.requestFailed(statusCode: retryHTTP.statusCode) }
                return try decodeResponse(retryData, jsonMode: jsonMode)
            }
        }

        guard (200...299).contains(http.statusCode) else { throw AIError.requestFailed(statusCode: http.statusCode) }
        return try decodeResponse(data, jsonMode: jsonMode)
    }

    // MARK: - Response Decoder
    private func decodeResponse(_ data: Data, jsonMode: Bool) throws -> String {
        do {
            let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
            guard let candidate = decoded.candidates?.first else { throw AIError.emptyResponse }

            let text = candidate.content.parts.first?.text

            if candidate.finishReason == "MAX_TOKENS" {
                #if DEBUG
                print("⚠️ Gemini response truncated (MAX_TOKENS). jsonMode=\(jsonMode). Partial text: \(text ?? "nil")")
                #endif
                if jsonMode {
                    throw AIError.truncated
                }
            }

            guard let text, !text.isEmpty else { throw AIError.emptyResponse }
            return text
        } catch is DecodingError {
            throw AIError.decodingFailed
        }
    }
}


