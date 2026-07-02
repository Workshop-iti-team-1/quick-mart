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
            if let imageURLStr = product.images.first?.url, let url = URL(string: imageURLStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
                .background(Color.grey50)
                .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
                    .background(Color.grey50)
                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
            }
        }
    }
}
