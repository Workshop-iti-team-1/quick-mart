//
//  BrandItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation

struct BrandItem: Identifiable, Hashable {
    let id: String
    let name: String
    /// Name of an asset in the Asset Catalog, or an SF Symbol name used as a placeholder.
    /// When Shopify integration arrives, swap this with a remote URL and update the view layer only.
    let imageName: String
    let isSystemImage: Bool
}
