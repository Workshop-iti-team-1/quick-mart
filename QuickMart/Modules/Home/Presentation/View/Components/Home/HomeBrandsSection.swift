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

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Brands", onSeeAll: onSeeAll)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(items) { item in
                        HomeBrandCell(item: item)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}
