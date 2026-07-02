//
//  LatestProductsSection.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import SwiftUI

struct LatestProductsSection: View {
    let items: [ProductSearchItem]
    let onSeeAll: () -> Void
    @Environment(AppRouter.self) var router

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Latest Products", onSeeAll: onSeeAll)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    Button(action: {
                        router.push(.productDetails(productId: item.id))
                    }) {
                        ProductCard(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
