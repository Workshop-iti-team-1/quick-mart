//
//  CategoryView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 29/06/2026.
//
// Features/Category/Presentation/Views/CategoryView.swift

// Features/Category/Presentation/Views/CategoryView.swift

import SwiftUI

struct CategoryView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel: CategoryViewModel

    // MARK: - Init

    init(viewModel: CategoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Private Constants

    private enum Layout {
        static let columns: Int               = 2
        static let gridSpacing: CGFloat       = 12
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat        = 12
        static let bottomPadding: CGFloat     = 24
    }

    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: Layout.gridSpacing),
            count: Layout.columns
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.backGround
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
            } else {
                categoryGrid
            }
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.loadCategories() }
    }

    // MARK: - Subviews

    private var categoryGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing) {
                ForEach(viewModel.categories) { item in
                    CategoryGridItemView(item: item)
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
            .padding(.bottom, Layout.bottomPadding)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NavigationLink("Go to Categories") {
            CategoryView(
                viewModel: DIContainer.shared.makeCategoryViewModel()
            )
        }
        .padding()
    }
}
