//
//  PredictiveSuggestionRowView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 04/07/2026.
//

import SwiftUI

struct PredictiveSuggestionRowView: View {

    let suggestion: PredictiveSuggestion
    let onTap: () -> Void

    private enum Layout {
        static let imageSize: CGFloat       = 40
        static let cornerRadius: CGFloat    = 8
        static let rowVerticalPad: CGFloat  = 10
        static let spacing: CGFloat         = 12
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Layout.spacing) {
                thumbnailView
                labelView
                Spacer(minLength: 0)
                chevron
            }
            .contentShape(Rectangle())
            .padding(.vertical, Layout.rowVerticalPad)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Thumbnail

    @ViewBuilder
    private var thumbnailView: some View {
        switch suggestion {
        case .product(let product):
            AsyncImage(url: product.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    placeholderIcon(systemName: "photo")
                @unknown default:
                    placeholderIcon(systemName: "photo")
                }
            }
            .frame(width: Layout.imageSize, height: Layout.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .background(
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color.grey50)
            )

        case .collection(let collection):
            AsyncImage(url: collection.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    placeholderIcon(systemName: "folder.fill")
                @unknown default:
                    placeholderIcon(systemName: "folder.fill")
                }
            }
            .frame(width: Layout.imageSize, height: Layout.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
            .background(
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color.grey50)
            )
        }
    }

    private func placeholderIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 18))
            .foregroundColor(.grey150)
            .frame(width: Layout.imageSize, height: Layout.imageSize)
    }

    // MARK: - Label

    @ViewBuilder
    private var labelView: some View {
        switch suggestion {
        case .product(let product):
            VStack(alignment: .leading, spacing: 2) {
                Text(product.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(1)

                Text(product.vendor)
                    .appTextStyle(.caption, color: .grayText)
                    .lineLimit(1)

                Text(
                    String(
                        format: "%@ %.2f",
                        currencySymbol(for: product.currencyCode),
                        product.minPrice
                    )
                )
                .appTextStyle(.caption, color: .cyanPrimary)
            }

        case .collection(let collection):
            VStack(alignment: .leading, spacing: 2) {
                Text(collection.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(1)

                Text("Collection")
                    .appTextStyle(.caption, color: .grayText)
            }
        }
    }

    // MARK: - Chevron

    private var chevron: some View {
        Image(systemName: "arrow.up.left")
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.grey150)
    }

    // MARK: - Helpers

    private func currencySymbol(for code: String) -> String {
        let locale = Locale.availableIdentifiers
            .map { Locale(identifier: $0) }
            .first { $0.currency?.identifier == code }
        return locale?.currencySymbol ?? code
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        PredictiveSuggestionRowView(
            suggestion: .product(
                PredictiveProduct(
                    id: "1",
                    title: "Loop Silicone Headphones",
                    vendor: "Sony",
                    minPrice: 15.25,
                    currencyCode: "USD",
                    imageURL: nil
                )
            ),
            onTap: {}
        )
        Divider()
            .padding(.leading, 64)
        PredictiveSuggestionRowView(
            suggestion: .collection(
                PredictiveCollection(
                    id: "2",
                    title: "Men",
                    handle: "men",
                    imageURL: nil
                )
            ),
            onTap: {}
        )
    }
    .padding(.horizontal, 16)
    .background(Color.backGround)
}
