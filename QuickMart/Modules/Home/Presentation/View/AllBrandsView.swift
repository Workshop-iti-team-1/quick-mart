//
//  BrandView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import SwiftUI

struct AllBrandsView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel: BrandViewModel

    // MARK: - Init

    init(viewModel: BrandViewModel) {
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
                brandGrid
            }
        }
        .navigationTitle("Brands")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.loadBrands() }
    }

    // MARK: - Subviews

    private var brandGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing) {
                ForEach(viewModel.brands) { item in
                    BrandGridItemView(item: item)
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
        NavigationLink("Go to Brands") {
            AllBrandsView(
                viewModel: DIContainer.shared.makeBrandViewModel()
            )
        }
        .padding()
    }
}
