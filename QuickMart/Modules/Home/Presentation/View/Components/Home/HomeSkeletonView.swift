//
//  HomeSkeletonView.swift
//  QuickMart
//
//  Created by siam on 11/07/2026.
//

import SwiftUI

struct HomeSkeletonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Banners Skeleton
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.shimmerBase)
                        .frame(height: 150)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    
                    HStack(spacing: 6) {
                        ForEach(0..<4, id: \.self) { i in
                            Capsule()
                                .fill(Color.shimmerBase)
                                .frame(width: i == 0 ? 20 : 6, height: 6)
                        }
                    }
                }
                
                // Brands Skeleton
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.shimmerBase)
                            .frame(width: 100, height: 28)
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.shimmerBase)
                            .frame(width: 50, height: 16)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<4, id: \.self) { _ in
                                VStack(spacing: 10) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.shimmerBase)
                                        .frame(width: 48, height: 48)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.shimmerBase)
                                        .frame(width: 60, height: 14) // Exactly matching caption text height
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                    }
                }
                
                // Categories Skeleton
                VStack(alignment: .leading, spacing: 14) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.shimmerBase)
                        .frame(width: 120, height: 28)
                        
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                        ForEach(0..<4, id: \.self) { _ in
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.shimmerBase)
                                    .frame(height: 160) // Match the 160 height
                                    
                                HStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.shimmerBase)
                                        .frame(width: 80, height: 16) // Match the 16 text height
                                    Spacer()
                                }
                                .padding(.vertical, 12) // Match the 12 vertical padding
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
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .shimmer()
    }
}

#Preview {
    HomeSkeletonView()
}
