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
    @EnvironmentObject var currencyManager: CurrencyManagerService

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
                        set: { _ in }
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

            // MARK: - Price — keyed on selectedCurrency to force redraw
            HStack(spacing: 6) {
                Text(currencyManager.format(defultAppCurrency: item.price))
                    .appTextStyle(.label, color: .appBlack)
                    .id("price-\(item.id)-\(currencyManager.selectedCurrency)")

                if let originalPrice = originalPriceValue, originalPrice > item.price {
                    Text(currencyManager.format(defultAppCurrency: originalPrice))
                        .appTextStyle(.caption, color: .grayText)
                        .strikethrough(true, color: .grayText)
                        .id("original-\(item.id)-\(currencyManager.selectedCurrency)")

                    let discount = Int(((originalPrice - item.price) / originalPrice) * 100)
                    Text("-\(discount)%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                }
            }
        }
    }

    private var originalPriceValue: Double? {
        guard let prices = item.originalPrice, !prices.isEmpty else { return nil }
        return prices.max()
    }
}
