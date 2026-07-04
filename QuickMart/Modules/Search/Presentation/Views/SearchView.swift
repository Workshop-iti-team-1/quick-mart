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
    @Environment(AppRouter.self) private var router
    @FocusState private var isSearchFocused: Bool

    // MARK: - Init
    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Layout
    private enum Layout {
        static let horizontalPad: CGFloat = 16
        static let searchBarRadius: CGFloat = 25
        static let gridSpacing: CGFloat = 12
        static let gridColumns = 2
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
            Color.backGround
                .ignoresSafeArea()
                .contentShape(Rectangle())  // Ensures the whole area is tappable
                .onTapGesture {
                    isSearchFocused = false  //  Drops the keyboard
                }

            VStack(spacing: 0) {
                //headerView
                searchBarView
                    .padding(.bottom, 16)
                contentView
            }
        }
        .onAppear {
            // Catch queued filters from Home/Brands tab switch
            if let externalFilters = router.queuedSearchFilters {
                viewModel.applyExternalFilters(externalFilters)
                // Clear queue so it doesn't fire again if the user just navigates normally
                router.queuedSearchFilters = nil
            }
        }
        .task {
            // Fallback to normal initial load ONLY if no external filters were caught
            if router.queuedSearchFilters == nil {
                await viewModel.loadInitialData()
            }
        }
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
                .onSubmit {
                    viewModel.commitSearch()
                    isSearchFocused = false  // Ensure focus drops on return
                }

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
            isSearchFocused = false  // Drop keyboard if opening filters
            viewModel.showFilter()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(
                        viewModel.hasActiveFilters ? .cyanPrimary : .appBlack)

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
        if isSearchFocused && viewModel.searchText.isEmpty {
            // State 1: Focused, no text → recent searches
            recentSearchesView

        } else if isSearchFocused && !viewModel.searchText.isEmpty {
            // State 2: Focused, typing → predictive suggestions
            predictiveView

        } else {
            // State 3: Unfocused → full results or empty state
            activeSearchContent
        }
    }

    // MARK: - Recent Searches
    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("RECENT SEARCH")
                .appTextStyle(.caption, color: .grayText)
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.bottom, 4)

            List {
                ForEach(viewModel.recentSearches, id: \.self) { query in
                    RecentSearchRowView(query: query) {
                        viewModel.selectRecentSearch(query)
                        isSearchFocused = false  // Drop keyboard to reveal results
                    }
                    .listRowInsets(
                        EdgeInsets(
                            top: 0, leading: Layout.horizontalPad, bottom: 0,
                            trailing: Layout.horizontalPad)
                    )
                    .listRowSeparatorTint(Color.grey100)
                    .listRowBackground(Color.backGround)
                }
                .onDelete { indexSet in
                    // Map the swiped index to the actual query string and remove it
                    for index in indexSet {
                        let queryToDelete = viewModel.recentSearches[index]
                        viewModel.removeRecentSearch(queryToDelete)
                    }
                }
            }
            .listStyle(.plain)  // Removes default List styling
            .scrollContentBackground(.hidden)  // Ensures your background color shows through
            .scrollDismissesKeyboard(.immediately)
        }
        .frame(
            maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    // MARK: - Predictive Suggestions

    @ViewBuilder
    private var predictiveView: some View {
        if viewModel.isPredictiveSearching
            && viewModel.predictiveSuggestions.isEmpty
        {
            // First load — subtle inline spinner, not full-screen
            HStack {
                ProgressView()
                    .scaleEffect(0.8)
                Text("Searching...")
                    .appTextStyle(.caption, color: .grayText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        } else if viewModel.hasPredictiveSuggestions {
            List {
                ForEach(viewModel.predictiveSuggestions) { suggestion in

                    let dynamicLabel: String? = {
                        if case .collection(let collection) = suggestion {
                            return viewModel.getCollectionLabel(
                                for: collection.title)
                        }
                        return nil
                    }()

                    PredictiveSuggestionRowView(
                        suggestion: suggestion, collectionLabel: dynamicLabel
                    ) {
                        viewModel.selectSuggestion(suggestion)
                        isSearchFocused = false
                    }
                    .listRowInsets(
                        EdgeInsets(
                            top: 0,
                            leading: Layout.horizontalPad,
                            bottom: 0,
                            trailing: Layout.horizontalPad
                        )
                    )
                    .listRowSeparatorTint(Color.grey100)
                    .listRowBackground(Color.backGround)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)

        } else if !viewModel.isPredictiveSearching {
            // Non-empty query but no suggestions returned
            VStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 36))
                    .foregroundColor(.grey100)
                Text("No suggestions found")
                    .appTextStyle(.body, color: .grayText)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
                    Button {
                        // 1. Dismiss the fullScreenCover
                        dismiss()
                        // 2. Push the detail view onto the main stack
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            router.push(.productDetails(productId: item.id))
                        }
                    } label: {
                        ProductCard(item: item)
                    }
                    .buttonStyle(.plain)  // Prevents the whole card from looking like a default text button
                }
            }
            .padding(.horizontal, Layout.horizontalPad)
            .padding(.bottom, 24)
        }.scrollDismissesKeyboard(.immediately)
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
//
//#Preview {
//    SearchView(
//        viewModel: SearchViewModel(
//            searchProductsUseCase: SearchProductsUseCase(repository: MockSearchRepository()),
//            fetchSubCategoriesUseCase: FetchSubCategoriesUseCase(repository: MockSearchRepository()),
//            fetchCategoriesUseCase: FetchCategoriesUseCase(repository: MockHomeRepository()),
//            fetchBrandsUseCase: FetchBrandsUseCase(repository: MockHomeRepository()),
//            repository: MockSearchRepository()
//        )
//    )
//}
