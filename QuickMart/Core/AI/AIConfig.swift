//
//  AIConfig.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  AIConfig.swift
//  QuickMart
//
import Foundation

struct AIConfig {
    static let textModel = "gemini-3.5-flash"
    static let visionModel = "gemini-3.5-flash" // same model handles images, free tier
    static var baseURL: String {
        "https://generativelanguage.googleapis.com/v1beta/models"
    }
    static var apiKey: String { value(for: "GEMINI_API_KEY") }

    private static func value(for key: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty
        else { fatalError("Key \(key) is missing or empty in Info.plist") }
        return value
    }
}
