//
//  ProductImageHeader.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductImageHeader: View {
    let product: ProductDetails

    var body: some View {
        ZStack(alignment: .top) {
            if let imageURLStr = product.images.first?.url,
               let url = URL(string: imageURLStr)
            {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.shimmerBase)
                            .frame(height: 380)
                            .frame(maxWidth: .infinity)
                            .shimmer()
                            
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(24)
                            .frame(maxWidth: .infinity)
                            
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .frame(height: 380)
                            .frame(maxWidth: .infinity)
                            
                    @unknown default:
                        EmptyView()
                    }
                }
                .background(Color.grey50)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 380)
                    .padding()
                    .background(Color.grey50)
            }
        }
    }
}
