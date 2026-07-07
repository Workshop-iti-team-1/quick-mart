//
//  AIConfig.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//



import Foundation

struct AIConfig {
    static let textModel = "gemini-3.5-flash" 
    static let visionModel = "gemini-3.5-flash"
    static var baseURL: String {
        "https://generativelanguage.googleapis.com/v1beta/models"
    }

    /// One key per SEPARATE Google Cloud project (billing disabled on each).
    /// Keys from the SAME project share one quota pool — rotating between them does nothing.
    static let apiKeys: [String] = [
        value(for: "GEMINI_API_KEY_1"),
        value(for: "GEMINI_API_KEY_2"),
        value(for: "GEMINI_API_KEY_3"),
        value(for: "GEMINI_API_KEY_4")
    ]

    private static func value(for key: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty
        else { fatalError("Key \(key) is missing or empty in Info.plist") }
        return value
    }
}
