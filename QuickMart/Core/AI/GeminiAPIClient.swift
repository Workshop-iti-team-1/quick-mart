//
//  GeminiAPIClient.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.

//
//  GeminiAPIClient.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import Foundation

final class GeminiAPIClient: GeminiAPIClientProtocol {
    private let session: URLSession

    // MARK: - Rate Limiting
    /// Tracks when the last request was sent to enforce spacing.
    private var lastRequestTime: Date = .distantPast
    /// Minimum seconds between consecutive requests (~15 RPM safe margin).
    private let minRequestInterval: TimeInterval = 4
    /// Lock to make lastRequestTime access thread-safe.
    private let lock = NSLock()

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Public API
    func generate(prompt: String, imageData: Data?, model: String, maxTokens: Int = 1024) async throws -> String {
        // Throttle: wait if we're sending too fast
        try await throttleIfNeeded()

        // Build the request
        let request = try buildRequest(prompt: prompt, imageData: imageData, model: model, maxTokens: maxTokens)

        // Execute with single retry on 429
        return try await executeWithRetry(request: request)
    }

    // MARK: - Throttling
    /// Sleeps if the last request was sent less than `minRequestInterval` seconds ago.
    private func throttleIfNeeded() async throws {
        let waitTime: TimeInterval
        lock.lock()
        let elapsed = Date().timeIntervalSince(lastRequestTime)
        if elapsed < minRequestInterval {
            waitTime = minRequestInterval - elapsed
        } else {
            waitTime = 0
        }
        lastRequestTime = Date().addingTimeInterval(max(waitTime, 0))
        lock.unlock()

        if waitTime > 0 {
            try await Task.sleep(nanoseconds: UInt64(waitTime * 1_000_000_000))
        }
    }

    // MARK: - Request Builder
    private func buildRequest(prompt: String, imageData: Data?, model: String, maxTokens: Int) throws -> URLRequest {
        guard let url = URL(string: "\(AIConfig.baseURL)/\(model):generateContent") else {
            throw AIError.invalidURL
        }

        var parts: [[String: Any]] = [["text": prompt]]
        if let imageData {
            parts.append([
                "inline_data": [
                    "mime_type": "image/jpeg",
                    "data": imageData.base64EncodedString()
                ]
            ])
        }

        let body: [String: Any] = [
            "contents": [["parts": parts]],
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": maxTokens
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AIConfig.apiKey, forHTTPHeaderField: "x-goog-api-key")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }

    // MARK: - Execute with Retry
    /// Executes the request. On a 429 response, waits 10 seconds and retries once.
    private func executeWithRetry(request: URLRequest) async throws -> String {
        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // Rate limited — wait and retry once
        if http.statusCode == 429 {
            try await Task.sleep(nanoseconds: 10_000_000_000) // 10 seconds

            lock.lock()
            lastRequestTime = Date()
            lock.unlock()

            let (retryData, retryResponse) = try await session.data(for: request)

            guard let retryHTTP = retryResponse as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            // If still 429 after retry, throw user-friendly error
            if retryHTTP.statusCode == 429 {
                throw AIError.rateLimited
            }

            guard (200...299).contains(retryHTTP.statusCode) else {
                throw AIError.requestFailed(statusCode: retryHTTP.statusCode)
            }

            return try decodeResponse(retryData)
        }

        guard (200...299).contains(http.statusCode) else {
            throw AIError.requestFailed(statusCode: http.statusCode)
        }

        return try decodeResponse(data)
    }

    // MARK: - Response Decoder
    private func decodeResponse(_ data: Data) throws -> String {
        do {
            let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
            guard let text = decoded.candidates?.first?.content.parts.first?.text, !text.isEmpty else {
                throw AIError.emptyResponse
            }
            return text
        } catch is DecodingError {
            throw AIError.decodingFailed
        }
    }
}
