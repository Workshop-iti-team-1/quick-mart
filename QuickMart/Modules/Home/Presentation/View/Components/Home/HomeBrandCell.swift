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

                if let imageName = item.imageName {
                    if item.isSystemImage == true {
                        Image(systemName: imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.cyanPrimary)
                    } else {
                        AsyncImage(url: URL(string: imageName)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.grey150)
                            case .empty:
                                ProgressView()
                                    .frame(width: 28, height: 28)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                } else {
                    // no image at all — fallback
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.grey150)
                }
            }

            Text(item.name)
                .appTextStyle(.caption, color: .appBlack)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }
}
