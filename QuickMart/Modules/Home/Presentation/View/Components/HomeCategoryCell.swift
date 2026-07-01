//
//  HomeCategoryCell.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import SwiftUI

struct HomeCategoryCell: View {
    let item: BrandItem

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.grey50)
                    .frame(width: 60, height: 60)

                Group {
                    if item.isSystemImage {
                        Image(systemName: item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.cyanPrimary)
                    } else {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    }
                }
            }

            Text(item.name)
                .appTextStyle(.caption, color: .appBlack)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(width: 68)
        }
    }
}

// MARK: - Section
struct HomeCategoriesSection: View {
    let items: [BrandItem]
    let onSeeAll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Categories", onSeeAll: onSeeAll)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(items) { item in
                        HomeCategoryCell(item: item)
                    }
                }
            }
        }
    }
}
