//
//  SearchView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import SwiftUI

struct SearchView: View {

    @StateObject private var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFocused: Bool

    // MARK: - Init

    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Layout

    private enum Layout {
        static let horizontalPad: CGFloat   = 16
        static let searchBarRadius: CGFloat = 25
        static let gridSpacing: CGFloat     = 12
        static let gridColumns              = 2
    }

    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: Layout.gridSpacing),
            count: Layout.gridColumns
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                headerView
                searchBarView
                    .padding(.bottom, 16)
                contentView
            }
        }
        .onAppear { isSearchFocused = true }
        .sheet(isPresented: $viewModel.isFilterPresented) {
            SearchFilterBottomSheet(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(20)
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Image("quickmartApp")
                .resizable()
                .scaledToFit()
                .frame(height: 28)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appBlack)
            }
        }
        .padding(.horizontal, Layout.horizontalPad)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }

    // MARK: - Search Bar

    private var searchBarView: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundColor(.grey150)

            TextField("Search", text: $viewModel.searchText)
                .appTextStyle(.body, color: .appBlack)
                .focused($isSearchFocused)
                .submitLabel(.search)
                .onSubmit { viewModel.commitSearch() }

            Spacer(minLength: 0)

            filterButton
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: Layout.searchBarRadius)
                .stroke(Color.grey100, lineWidth: 1)
        )
        .padding(.horizontal, Layout.horizontalPad)
    }

    private var filterButton: some View {
        Button {
            viewModel.showFilter()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16))
                    .foregroundColor(viewModel.hasActiveFilters ? .cyanPrimary : .appBlack)

                if viewModel.hasActiveFilters {
                    Circle()
                        .fill(Color.cyanPrimary)
                        .frame(width: 7, height: 7)
                        .offset(x: 3, y: -3)
                }
            }
        }
    }

    // MARK: - Content State Machine

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isSearchActive {
            activeSearchContent
        } else {
            recentSearchesView
        }
    }

    // MARK: - Recent Searches

    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("RECENT SEARCH")
                .appTextStyle(.caption, color: .grayText)
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.bottom, 4)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(viewModel.recentSearches, id: \.self) { query in
                        RecentSearchRowView(query: query) {
                            viewModel.selectRecentSearch(query)
                        }
                        .padding(.horizontal, Layout.horizontalPad)
                        Divider()
                            .padding(.leading, Layout.horizontalPad)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    // MARK: - Active Search

    @ViewBuilder
    private var activeSearchContent: some View {
        if viewModel.isSearching {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.hasResults {
            resultsGrid
        } else {
            emptyStateView
        }
    }

    private var resultsGrid: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridColumns, spacing: Layout.gridSpacing) {
                ForEach(viewModel.searchResults) { item in
                    ProductCard(item: item)
                }
            }
            .padding(.horizontal, Layout.horizontalPad)
            .padding(.bottom, 24)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundColor(.grey100)

            Text("No results found")
                .appTextStyle(.heading2, color: .appBlack)

            Text("Try different keywords or\nadjust your filters.")
                .appTextStyle(.body, color: .grayText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview {
    SearchView(
        viewModel: SearchViewModel(
            searchProductsUseCase: SearchProductsUseCase(repository: MockSearchRepository()),
            fetchSubCategoriesUseCase: FetchSubCategoriesUseCase(repository: MockSearchRepository()),
            fetchCategoriesUseCase: FetchCategoriesUseCase(repository: MockHomeRepository()),
            fetchBrandsUseCase: FetchBrandsUseCase(repository: MockHomeRepository()),
            repository: MockSearchRepository()
        )
    )
}
