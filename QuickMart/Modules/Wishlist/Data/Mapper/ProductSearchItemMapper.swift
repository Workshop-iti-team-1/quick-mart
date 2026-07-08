//
//  ProductSearchItemMapper.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//

// Data/Mappers/ProductSearchItem+Mapping.swift
extension ProductSearchItem {
    /// Best-effort ProductDetails built from list data. If the user opens the
    /// full detail screen later, syncIfFavorite() upgrades this to the richer version.
    func toMinimalProductDetails() -> ProductDetails {
        ProductDetails(
            id: id, title: name, description: "", vendor: brandID ?? "",
            productType: subCategoryID ?? "", tags: [], availableForSale: true,
            minPrice: price, maxPrice: price, currencyCode: "USD",
            compareAtPrice: originalPrice?.first,
            images: isSystemImage ? [] : [ProductImage(id: id, url: imageName, altText: name)],
            options: [], variants: [], rating: 0, reviewsCount: 0
        )
    }
}
