//
//  CategoryGridCell.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

// Features/Category/Presentation/Components/CategoryGridCell.swift
import SwiftUI

struct CategoryGridCell: View {
    let item: CategoryItem

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                // Background is only needed if using a transparent system image
                if item.isSystemImage {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cyan50)
                        .frame(width: 150, height: 150)
                }

                Group {
                    if item.isSystemImage {
                        Image(systemName: item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.cyanPrimary)
                    } else {
                        // Custom image styling: Fills the entire box cleanly
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150) // Matches the full background size
                            .clipShape(RoundedRectangle(cornerRadius: 12)) // Keeps the rounded corners
                    }
                }
            }

            Text(item.name)
                .appTextStyle(.label, color: .appBlack)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(12)
        .background(Color.appWhite)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
