//
//  ProductDetailsSkeletonView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 07/07/2026.
//

import SwiftUI

// MARK: - Skeleton View
struct ProductDetailsSkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Fake Image Header
                Rectangle()
                    .fill(Color.shimmerBase)
                    .frame(height: 380)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Fake Badges
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 80, height: 24)
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 100, height: 24)
                    }
                    
                    // Fake Title and Price
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 200, height: 24)
                            RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 150, height: 24)
                        }
                        Spacer()
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 80, height: 24)
                    }
                    
                    // Fake Rating
                    RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 140, height: 16)
                    
                    // Fake Description lines
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(height: 14)
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(height: 14)
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(height: 14)
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 200, height: 14)
                    }
                    
                    // Fake AI Buttons
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 10).fill(Color.shimmerBase).frame(width: 100, height: 36)
                        RoundedRectangle(cornerRadius: 10).fill(Color.shimmerBase).frame(width: 140, height: 36)
                    }

                    // Fake Options (Color)
                    VStack(alignment: .leading, spacing: 12) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 50, height: 16)
                        HStack(spacing: 12) {
                            ForEach(0..<4, id: \.self) { _ in
                                Circle().fill(Color.shimmerBase).frame(width: 32, height: 32)
                            }
                        }
                    }
                    
                    // Fake Options (Size)
                    VStack(alignment: .leading, spacing: 12) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.shimmerBase).frame(width: 40, height: 16)
                        HStack(spacing: 12) {
                            ForEach(0..<5, id: \.self) { _ in
                                Capsule().fill(Color.shimmerBase).frame(width: 45, height: 40)
                            }
                        }
                    }
                }
                .padding(24)
                .background(Color.cardBackground)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .padding(.top, -24)
            }
        }
        .redacted(reason: .placeholder)
        .shimmer()
    }
}
