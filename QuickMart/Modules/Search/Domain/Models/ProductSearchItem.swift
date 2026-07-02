//
//  ProductSearchItem.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

/// Domain model for a single product.
///
/// Filter key Shopify mapping:
/// - categoryID    → collection handle / ID
/// - subCategoryID → product type string
/// - brandID       → vendor string
struct ProductSearchItem: Identifiable, Hashable {

    let id: String
    let name: String
    let imageName: String
    let isSystemImage: Bool
    let price: Double
    let originalPrice: [Double]?
    let colorNames: [String]
    let colorCount: Int
    var isFavorite: Bool

    // MARK: - Filter Keys (optional — nil-safe in all filter logic)
    let categoryID: String?
    let subCategoryID: String?
    let brandID: String?

    // Default values ensure all existing ProductSearchItem initialisations remain valid
    init(
        id: String,
        name: String,
        imageName: String,
        isSystemImage: Bool = true,
        price: Double,
        originalPrice: [Double]? = nil,
        colorNames: [String] = [],
        colorCount: Int = 0,
        isFavorite: Bool = false,
        categoryID: String? = nil,
        subCategoryID: String? = nil,
        brandID: String? = nil
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.isSystemImage = isSystemImage
        self.price = price
        self.originalPrice = originalPrice
        self.colorNames = colorNames
        self.colorCount = colorCount
        self.isFavorite = isFavorite
        self.categoryID = categoryID
        self.subCategoryID = subCategoryID
        self.brandID = brandID
    }
}
