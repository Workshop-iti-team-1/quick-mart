//
//  CategoryDetailView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


// Features/Category/Presentation/Views/CategoryDetailView.swift
import SwiftUI

struct CategoryDetailView: View {
    let category: CategoryItem

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            Text("Products for \(category.name)")
                .appTextStyle(.body, color: .appBlack)
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
