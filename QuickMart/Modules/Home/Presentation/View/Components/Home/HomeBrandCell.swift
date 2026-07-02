//
//  HomeBrandCell.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import SwiftUI

struct HomeBrandCell: View {
    let item: BrandItem

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.grey50)
                    .frame(width: 64, height: 64)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)

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
        }
    }
}


