//
//  ProductCard.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import SwiftUI

struct ProductCard: View {
    let item: ProductSearchItem
    @ObservedObject private var favouriteViewModel = FavouriteViewModel.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.grey50)
                    .frame(height: 140)
                    .overlay(
                        Group {
                            if item.isSystemImage {
                                Image(systemName: item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                                    .foregroundColor(.grey150)
                            } else {
                                AsyncImage(url: URL(string: item.imageName)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80)
                                    default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80)
                                            .foregroundColor(.grey150)
                                    }
                                }
                            }
                        }
                    )

                FavoriteButton(
                    isFavorite: .init(
                        get: { favouriteViewModel.isFavorite(item.id) },
                        set: { _ in } // mutation happens in onToggle, not here
                    ),
                    onToggle: { newValue in
                        let product = item.toMinimalProductDetails()
                        if newValue {
                            favouriteViewModel.addFavorite(product)
                        } else {
                            favouriteViewModel.removeFavorite(id: item.id)
                        }
                    }
                )
                .padding(8)
            }
            ColorSwatches(colorNames: item.colorNames, totalCount: item.colorCount)
            Text(item.name)
                .appTextStyle(.label, color: .appBlack)
                .lineLimit(1)
            HStack(spacing: 6) {
                Text(String(format: "$%.2f", item.price))
                    .appTextStyle(.label, color: .appBlack)
                if let originalPriceText = formattedOriginalPrice {
                    Text(originalPriceText)
                        .appTextStyle(.caption, color: .grayText)
                        .strikethrough(true, color: .grayText)
                }
            }
        }
    }

    // MARK: - Helpers

    /// Formats the originalPrice array for display.
    /// nil / empty  → hidden
    /// [x]          → "$x.xx"
    /// [min, max]   → "$min.xx – $max.xx"
    private var formattedOriginalPrice: String? {
        guard let prices = item.originalPrice, !prices.isEmpty else { return nil }
        if prices.count == 1 {
            return String(format: "$%.2f", prices[0])
        }
        let sorted = prices.sorted()
        return String(format: "$%.2f – $%.2f", sorted[0], sorted[sorted.count - 1])
    }
}
