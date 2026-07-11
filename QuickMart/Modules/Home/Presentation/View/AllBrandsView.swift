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

    @Environment(AppRouter.self) private var router

    // MARK: - Init

    init(viewModel: BrandViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Private Constants

    private enum Layout {
        static let columns: Int = 2
        static let gridSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 12
        static let bottomPadding: CGFloat = 24
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
                // Detailed Skeleton Grid
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing)
                    {
                        ForEach(0..<12, id: \.self) { _ in
                            // Mimics the exact layout of HomeBrandCell
                            VStack(spacing: 12) {
                                Circle()
                                    .fill(Color.shimmerBase)
                                    .frame(width: 100, height: 100)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.shimmerBase)
                                    .frame(width: 90, height: 16)
                            }
                            .frame(height: 140) 
                        }
                    }
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.top, Layout.topPadding)
                    .padding(.bottom, Layout.bottomPadding)
                }
                .redacted(reason: .placeholder)
                .shimmer()
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
                    Button {
                        var filters = SearchFilters()
                        filters.selectedBrandIDs.insert(item.name)
                        router.switchTab(to: .search, with: filters)
                    } label: {
                        HomeBrandCell(item: item, size: 100)
                    }
                    .buttonStyle(.plain)
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
