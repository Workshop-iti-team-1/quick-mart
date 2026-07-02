//
//  HomeCategoriesSection.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import SwiftUI

struct HomeCategoriesSection: View {
    let items: [CategoryItem]
  
    let onCategoryTap: (CategoryItem) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Categories")

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(items.prefix(4)) { item in
                    Button {
                        onCategoryTap(item)
                    } label: {
                        CategoryGridCell(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
