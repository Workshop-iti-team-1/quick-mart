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
        VStack(spacing: 0) {
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.cyan50)
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.cyanPrimary)
                    )
            }
            
            Text(item.name.uppercased())
                .appTextStyle(.label, color: .appBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .background(Color.cardBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.grey100.opacity(colorScheme == .dark ? 0.1 : 0.4), lineWidth: 1)
        )
    }
}
