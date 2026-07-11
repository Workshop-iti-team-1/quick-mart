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

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top Image Section
            ZStack(alignment: .topTrailing) {
                Color.grey50
                
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
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                                    .foregroundColor(.grey150)
                            case .empty:
                                // Asset Loading Shimmer
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.shimmerBase)
                                    .frame(width: 80, height: 80)
                                    .shimmer()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

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
            .frame(height: 160)

            // Content Section
            VStack(alignment: .leading, spacing: 8) {
                ColorSwatches(
                    colorNames: item.colorNames, totalCount: item.colorCount)

                Text(item.name)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Price Section
                HStack(spacing: 6) {
                    Text(currencyManager.format(defultAppCurrency: item.price))
                        .appTextStyle(.heading3, color: .cyanPrimary)
                        .id("price-\(item.id)-\(currencyManager.selectedCurrency)")

                    if let originalPrice = originalPriceValue, originalPrice > item.price {
                        Text(currencyManager.format(defultAppCurrency: originalPrice))
                            .appTextStyle(.caption, color: .grayText)
                            .strikethrough(true, color: .grayText)
                            .id("original-\(item.id)-\(currencyManager.selectedCurrency)")

                        let discount = Int(((originalPrice - item.price) / originalPrice) * 100)
                        Text("-\(discount)%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.appWhite)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.appRed)
                            .cornerRadius(4)
                    }
                }
            }
            .padding(12)
        }
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.grey100.opacity(colorScheme == .dark ? 0.1 : 0.4), lineWidth: 1)
        )
    }

    private var originalPriceValue: Double? {
        guard let prices = item.originalPrice, !prices.isEmpty else {
            return nil
        }
        return prices.max()
    }
}
