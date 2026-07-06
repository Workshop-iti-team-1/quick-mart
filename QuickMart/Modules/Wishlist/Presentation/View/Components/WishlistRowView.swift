//
//  WishlistRowView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


// Presentation/Favorites/WishlistRowView.swift
import SwiftUI

struct WishlistRowView: View {
    let favorite: FavoriteProduct
    @EnvironmentObject var currencyManager: CurrencyManagerService

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grey50)
                .frame(width: 70, height: 70)
                .overlay(
                    AsyncImage(url: URL(string: favorite.imageURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFit().padding(8)
                        default:
                            Image(systemName: "photo").foregroundColor(.grey150)
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Text(currencyManager.format(defultAppCurrency: favorite.price))
                        .appTextStyle(.label, color: .appBlack)
                        .id("price-\(favorite.id)-\(currencyManager.selectedCurrency)")

                    if let compare = favorite.compareAtPrice, compare > favorite.price {
                        Text(currencyManager.format(defultAppCurrency: compare))
                            .appTextStyle(.caption, color: .grayText)
                            .strikethrough(true, color: .grayText)
                            .id("compare-\(favorite.id)-\(currencyManager.selectedCurrency)")
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}
