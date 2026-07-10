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

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            ZStack {
                Color.grey50
                AsyncImage(url: URL(string: favorite.imageURL ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty:
                        ProgressView()
                    default:
                        Image(systemName: "photo").foregroundColor(.grey150)
                    }
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product Details
            VStack(alignment: .leading, spacing: 8) {
                Text(favorite.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 6) {
                    Text(currencyManager.format(defultAppCurrency: favorite.price))
                        .appTextStyle(.heading3, color: .cyanPrimary)
                        .id("price-\(favorite.id)-\(currencyManager.selectedCurrency)")
                    
                    if let compare = favorite.compareAtPrice, compare > favorite.price {
                        Text(currencyManager.format(defultAppCurrency: compare))
                            .appTextStyle(.caption, color: .grayText)
                            .strikethrough(true, color: .grayText)
                            .id("compare-\(favorite.id)-\(currencyManager.selectedCurrency)")
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.grey100.opacity(colorScheme == .dark ? 0.1 : 0.5), lineWidth: 1)
        )
    }
}
