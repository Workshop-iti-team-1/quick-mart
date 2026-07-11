//
//  AIProductCard.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct AIProductCard: View {
    let product: ProductDetails
    var isHighlighted: Bool = false
    var size: CardSize = .regular
    @EnvironmentObject var currencyManager: CurrencyManagerService

    enum CardSize {
        case compact, regular, large

        var imageHeight: CGFloat {
            switch self {
            case .compact: return 100
            case .regular: return 130
            case .large:   return 160
            }
        }

        var cardWidth: CGFloat {
            switch self {
            case .compact: return 120
            case .regular: return 150
            case .large:   return 170
            }
        }

        var titleFont: AppTextStyle.TextStyle {
            switch self {
            case .compact: return .caption
            case .regular, .large: return .label
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: Image
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.grey50)
                    .frame(height: size.imageHeight)
                    .overlay(
                        AsyncImage(url: URL(string: product.images.first?.url ?? "")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .padding(8)
                                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.system(size: 22))
                                    .foregroundColor(.grey150)
                            default:
                                ProgressView()
                                    .tint(.cyanPrimary)
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if isHighlighted {
                    Image(systemName: "sparkles")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.appWhite)
                        .padding(5)
                        .background(
                            LinearGradient(
                                colors: [.cyanPrimary, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: .cyanPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
                        .padding(6)
                }
            }

            // MARK: Title
            Text(product.title)
                .appTextStyle(size.titleFont, color: .appBlack)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            // MARK: Vendor
            Text(product.vendor)
                .appTextStyle(.caption, color: .grey150)
                .lineLimit(1)

            // MARK: Rating
            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.appYellow)
                Text(String(format: "%.1f", product.rating))
                    .appTextStyle(.caption, color: .grey150)
                Text("(\(product.reviewsCount))")
                    .font(.system(size: 10))
                    .foregroundColor(.grey150)
            }

            // MARK: Price
            Text(currencyManager.format(defultAppCurrency: product.minPrice))
                .appTextStyle(.button, color: .cyanPrimary)
        }
        .padding(10)
        .frame(width: size.cardWidth)
        .background(isHighlighted ? Color.cyan50 : Color.backGround)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    isHighlighted
                        ? LinearGradient(colors: [.cyanPrimary, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [.grey100, .grey100], startPoint: .leading, endPoint: .trailing),
                    lineWidth: isHighlighted ? 2 : 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(isHighlighted ? 0.08 : 0.04), radius: isHighlighted ? 8 : 4, x: 0, y: 2)
    }
}
