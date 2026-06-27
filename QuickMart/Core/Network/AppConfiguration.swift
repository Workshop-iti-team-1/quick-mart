//
//  AppConfiguration.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import Foundation

public enum AppConfiguration {
    
    // Generic accessor for Plist values
    private static func value<T>(for key: String) -> T {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? T else {
            fatalError("CRITICAL: Invalid or missing key '\(key)' in Info.plist")
        }
        return value
    }
    
    // MARK: - Shopify API Configuration
    
    static var storeURL: URL {
        let urlString: String = value(for: "STORE_URL")
        // Handle the escaped forward slashes from your config template
        let cleanString = urlString.replacingOccurrences(of: "\\/", with: "/")
        guard let url = URL(string: cleanString) else {
            fatalError("CRITICAL: STORE_URL is invalid.")
        }
        return url
    }
    
    static var adminAPIToken: String {
        return value(for: "ADMIN_API_TOKEN")
    }
    
    static var apiKey: String {
        return value(for: "API_KEY")
    }
    
    static var apiSecretKey: String {
        return value(for: "API_SECRET_KEY")
    }
}
