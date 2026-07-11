//
//  CartItemRowView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct CartItemRowView: View {
    let item: CartLine
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onDelete: () -> Void

    @EnvironmentObject var currencyManager: CurrencyManagerService

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image
            ZStack {
                Color.grey100.opacity(0.3)

                if let imageUrl = item.merchandise.imageURL,
                    let url = URL(string: imageUrl)
                {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        // Asset Loading Shimmer
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.shimmerBase)
                            .frame(width: 80, height: 80)
                            .shimmer()
                    }
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.grey150)
                }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(12)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(item.merchandise.productTitle)
                        .appTextStyle(.body, color: .primary)
                        .lineLimit(2)

                    Spacer()

                }

                Text(item.merchandise.title)  // Variant title
                    .appTextStyle(.body, color: .grey150)
                    .font(.system(size: 12))

                Text(
                    currencyManager.format(
                        defultAppCurrency: item.merchandise.price)
                )
                .appTextStyle(.label, color: .primary)

                if let comparePrice = item.merchandise.compareAtPrice,
                    comparePrice > item.merchandise.price
                {
                    HStack(spacing: 6) {
                        Text(
                            currencyManager.format(
                                defultAppCurrency: comparePrice)
                        )
                        .strikethrough()
                        .appTextStyle(.body, color: .grey150)
                        .font(.system(size: 12))

                        let discount = Int(
                            ((comparePrice - item.merchandise.price)
                                / comparePrice) * 100)
                        Text("-\(discount)%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.appWhite)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.appRed)
                            .cornerRadius(4)
                    }
                }

                HStack {
                    // Stepper
                    HStack(spacing: 16) {
                        Button(action: onDecrement) {
                            Image(systemName: "minus")
                                .foregroundColor(.primary)
                        }

                        Text("\(item.quantity)")
                            .appTextStyle(.body, color: .primary)

                        Button(action: onIncrement) {
                            Image(systemName: "plus")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.grey100.opacity(0.3))
                    .cornerRadius(8)

                    Spacer()

                    // Delete Button
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.appRed)
                            .padding(8)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}
