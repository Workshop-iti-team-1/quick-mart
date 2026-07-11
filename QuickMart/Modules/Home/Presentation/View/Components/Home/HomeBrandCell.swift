//
//  HomeBrandCell.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import SwiftUI

struct HomeBrandCell: View {
    @Environment(\.colorScheme) var colorScheme
    let item: BrandItem
    var size: CGFloat = 64

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        colorScheme == .dark
                            ? Color(UIColor.darkGray) : Color.white
                    )
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)

                if let imageName = item.imageName {
                    if item.isSystemImage == true {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size * 0.45, height: size * 0.45)
                            .foregroundColor(.cyanPrimary)
                    } else {
                        AsyncImage(url: URL(string: imageName)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: size, height: size)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: size * 0.4, height: size * 0.4)
                                    .foregroundColor(.grey150)
                            case .empty:
                                Circle()
                                    .fill(Color.grey100)
                                    .frame(width: size, height: size)
                                    .shimmer()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .id(item.id)
                    }
                } else {
                    // no image at all — fallback
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.4, height: size * 0.4)
                        .foregroundColor(.grey150)
                }
            }

            Text(item.name)
                .appTextStyle(size > 64 ? .body : .caption, color: .appBlack)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }
}
