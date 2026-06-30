//
//  ProductCard.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import SwiftUI
struct ProductCard: View {
    let item: ProductItem
    @State private var isFavorite: Bool

    init(item: ProductItem) {
        self.item = item
        _isFavorite = State(initialValue: item.isFavorite)
    }

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
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                            }
                        }
                    )

                FavoriteButton(isFavorite: $isFavorite)
                    .padding(8)
            }

            ColorSwatches(colorNames: item.colorNames, totalCount: item.colorCount)

            Text(item.name)
                .appTextStyle(.label, color: .appBlack)
                .lineLimit(1)

            HStack(spacing: 6) {
                Text(String(format: "$%.2f", item.price))
                    .appTextStyle(.label, color: .appBlack)

                if let original = item.originalPrice {
                    Text(String(format: "$%.2f", original))
                        .appTextStyle(.caption, color: .grayText)
                        .strikethrough(true, color: .grayText)
                }
            }
        }
    }
}
