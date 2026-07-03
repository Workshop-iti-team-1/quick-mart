//
//  HomeBrandsSection.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//
import SwiftUI

struct HomeBrandsSection: View {
    let items: [BrandItem]
    let onSeeAll: () -> Void
    var onBrandTap: ((BrandItem) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Brands", onSeeAll: onSeeAll)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { item in
                        Button {
                            onBrandTap?(item)
                        } label: {
                            BrandGridItemView(item: item)
                        }
                        .buttonStyle(.plain)  // Prevents default button dimming/coloring
                    }
                }
            }
        }
    }
}
