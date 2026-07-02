//
//  SubCategory.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//


import Foundation

/// Represents a Shopify Product Type.
/// Maps from the Storefront API `productTypes` connection when GraphQL is wired.
struct SubCategory: Identifiable, Hashable {
    let id: String
    let name: String
}
