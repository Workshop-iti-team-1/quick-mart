//
//  CategoryGridCell.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import SwiftUI

struct CategoryGridCell: View {
    @Environment(\.colorScheme) var colorScheme
    let item: CategoryItem

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cyan50)
                    .frame(width: 150, height: 150)

                if let imageName = item.imageName {
                    if item.isSystemImage == true {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.cyanPrimary)
                    } else {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                } else {
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.grey150)
                }
            }

            Text(item.name)
                .appTextStyle(.label, color: .appBlack)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(12)
        // Dynamic background applied here
        .background( Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
