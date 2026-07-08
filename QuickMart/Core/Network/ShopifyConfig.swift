//
//  ShopifyConfig.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

struct ShopifyConfig {
    static var storeURL: URL {
        let urlString = value(for: "STORE_URL").replacingOccurrences(of: "\\", with: "")
        guard let url = URL(string: urlString) else {
            fatalError("Key STORE_URL is missing or empty in Info.plist")
        }
        return url
    }

    static var adminURL: URL {
        let urlString = value(for: "ADMIN_STORE_URL").replacingOccurrences(of: "\\", with: "")
        guard let url = URL(string: urlString) else {
            fatalError("Key ADMIN_STORE_URL is missing or empty in Info.plist")
        }
        return url
    }

    static var storefrontToken: String { value(for: "STOREFRONT_TOKEN") }
    static var apiKey: String { value(for: "API_KEY") }
    static var apiSecretKey: String { value(for: "API_SECRET_KEY") }
    static var adminToken: String { value(for: "ADMIN_TOKEN") }

    static var apolloHeaders: [String: String] {
        [
            "X-Shopify-Storefront-Access-Token": storefrontToken,
            "Content-Type": "application/json"
        ]
    }

    private static func value(for key: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty
        else { fatalError("Key \(key) is missing or empty in Info.plist") }
        return value
    }
}

enum SupabaseConfig {
    static var projectURL: String { 
        value(for: "SUPABASE_PROJECT_URL").replacingOccurrences(of: "\\", with: "")
    }
    static var anonKey: String { value(for: "SUPABASE_ANON_KEY") }
    static var bucketName: String { value(for: "SUPABASE_BUCKET_NAME") }

    private static func value(for key: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty
        else { fatalError("Key \(key) is missing or empty in Info.plist") }
        return value
    }
}

