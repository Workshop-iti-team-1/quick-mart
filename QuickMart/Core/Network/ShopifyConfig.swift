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

    static var storefrontToken: String {
        value(for: "STOREFRONT_TOKEN")
    }

    static var apiKey: String {
        value(for: "API_KEY")
    }

    static var apiSecretKey: String {
        value(for: "API_SECRET_KEY")
    }

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
        else {
            fatalError("Key \(key) is missing or empty in Info.plist")
        }
        return value
    }
}
