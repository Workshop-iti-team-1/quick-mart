//
//  BrandGridItemView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import SwiftUI

struct BrandGridItemView: View {
    let item: BrandItem

    private enum Layout {
        static let cornerRadius: CGFloat       = 12
        static let iconSize: CGFloat           = 48
        static let cardPadding: CGFloat        = 16
        static let shadowRadius: CGFloat       = 4
        static let shadowY: CGFloat            = 2
        static let shadowOpacity: Double       = 0.06
        static let spacingIconToLabel: CGFloat = 10
    }

    var body: some View {
        VStack(spacing: Layout.spacingIconToLabel) {
            iconView
            labelView
        }
        .frame(maxWidth: .infinity)
        .padding(Layout.cardPadding)
        .background(cardBackground)
    }

    @ViewBuilder
    private var iconView: some View {
        if let imageName = item.imageName {
            if item.isSystemImage == true {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
                    .foregroundColor(.cyanPrimary)
            } else {
                AsyncImage(url: URL(string: imageName)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: Layout.iconSize, height: Layout.iconSize)
                            .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: Layout.iconSize, height: Layout.iconSize)
                            .foregroundColor(.grey150)
                    case .empty:
                        ProgressView()
                            .frame(width: Layout.iconSize, height: Layout.iconSize)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: Layout.iconSize, height: Layout.iconSize)
                .foregroundColor(.grey150)
        }
    }

    private var labelView: some View {
        Text(item.name)
            .appTextStyle(.caption, color: .appBlack)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .fill(Color.appWhite)
            .shadow(
                color: Color.appBlack.opacity(Layout.shadowOpacity),
                radius: Layout.shadowRadius,
                x: 0,
                y: Layout.shadowY
            )
    }
}

#Preview {
    BrandGridItemView(
        item: BrandItem(
            id: "1",
            name: "Electronics",
            imageName: "desktopcomputer",
            isSystemImage: true
        )
    )
    .frame(width: 160)
    .padding()
    .background(Color.backGround)
}
