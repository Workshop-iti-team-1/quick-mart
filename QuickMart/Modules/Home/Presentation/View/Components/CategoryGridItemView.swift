//
//  CategoryGridItemView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


//
//  CategoryGridItemView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 29/06/2026.
//
import SwiftUI

struct CategoryGridItemView: View {

    // MARK: - Input

    let item: CategoryItem

    // MARK: - Private Constants

    private enum Layout {
        static let cornerRadius: CGFloat   = 12
        static let iconSize: CGFloat       = 48
        static let cardPadding: CGFloat    = 16
        static let shadowRadius: CGFloat   = 4
        static let shadowY: CGFloat        = 2
        static let shadowOpacity: Double   = 0.06
        static let spacingIconToLabel: CGFloat = 10
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: Layout.spacingIconToLabel) {
            iconView
            labelView
        }
        .frame(maxWidth: .infinity)
        .padding(Layout.cardPadding)
        .background(cardBackground)
    }

    // MARK: - Sub-views

    @ViewBuilder
    private var iconView: some View {
        Group {
            if item.isSystemImage {
                Image(systemName: item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
                    .foregroundColor(.cyanPrimary)
            } else {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
            }
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

// MARK: - Preview

#Preview {
    CategoryGridItemView(
        item: CategoryItem(
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
