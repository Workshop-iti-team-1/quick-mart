//
//  SearchViewModel.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

// Features/Search/Presentation/ViewModels/SearchViewModel.swift

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Search State

    @Published var searchText: String = ""
    @Published private(set) var searchResults: [ProductSearchItem] = []
    @Published private(set) var recentSearches: [String] = []
    @Published private(set) var isSearching: Bool = false
    @Published private(set) var errorMessage: String? = nil

    // MARK: - Pagination State

    @Published private(set) var hasNextPage: Bool = false
    @Published private(set) var isLoadingNextPage: Bool = false
    private var currentCursor: String? = nil

    // MARK: - Filter State

    @Published var pendingFilters: SearchFilters = SearchFilters()
    @Published private(set) var appliedFilters: SearchFilters = SearchFilters()
    @Published var isFilterPresented: Bool = false

    // MARK: - Filter Data

    @Published private(set) var filterCategories: [CategoryItem] = []
    @Published private(set) var filterBrands: [BrandItem] = []
    @Published private(set) var filterSubCategories: [SubCategory] = []

    // MARK: - Computed

    var isSearchActive: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }
    var hasResults: Bool { !searchResults.isEmpty }
    var hasActiveFilters: Bool { !appliedFilters.isEmpty }

    // MARK: - Dependencies

    private let searchProductsUseCase: SearchProductsUseCaseProtocol
    private let fetchSubCategoriesUseCase: FetchSubCategoriesUseCaseProtocol
    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private let fetchBrandsUseCase: FetchBrandsUseCaseProtocol
    private let repository: SearchRepositoryProtocol

    // MARK: - Init

    init(
        searchProductsUseCase: SearchProductsUseCaseProtocol,
        fetchSubCategoriesUseCase: FetchSubCategoriesUseCaseProtocol,
        fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol,
        fetchBrandsUseCase: FetchBrandsUseCaseProtocol,
        repository: SearchRepositoryProtocol
    ) {
        self.searchProductsUseCase = searchProductsUseCase
        self.fetchSubCategoriesUseCase = fetchSubCategoriesUseCase
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
        self.fetchBrandsUseCase = fetchBrandsUseCase
        self.repository = repository

        recentSearches = repository.fetchRecentSearches()
        setupSearchDebounce()
    }

    // MARK: - Debounce Setup

    private func setupSearchDebounce() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                Task { await self.performSearch(query: query, resetPagination: true) }
            }
            .store(in: &cancellables)
    }

    // MARK: - Initial Load

    /// Called from SearchView.task — loads first page of all products on appear.
    func loadInitialData() async {
        guard searchResults.isEmpty && !isSearching else { return }
        await performSearch(query: searchText, resetPagination: true)
    }

    // MARK: - Search Intents

    /// Core fetch method. `resetPagination: true` for new queries/filter changes.
    /// `resetPagination: false` only used internally by `loadNextPage()`.
    func performSearch(query: String, resetPagination: Bool) async {
        guard !isSearching else { return }

        let trimmed = query.trimmingCharacters(in: .whitespaces)

        if resetPagination {
            currentCursor = nil
            searchResults = []
        }

        isSearching = true
        errorMessage = nil

        do {
            let result = try await searchProductsUseCase.execute(
                query: trimmed,
                filters: appliedFilters,
                after: resetPagination ? nil : currentCursor
            )

            if resetPagination {
                searchResults = result.products
            } else {
                // Append for pagination — deduplicate by ID defensively
                let existingIDs = Set(searchResults.map(\.id))
                let newProducts = result.products.filter { !existingIDs.contains($0.id) }
                searchResults.append(contentsOf: newProducts)
            }

            hasNextPage   = result.hasNextPage
            currentCursor = result.endCursor

        } catch {
            errorMessage = error.localizedDescription
            if resetPagination { searchResults = [] }
        }

        isSearching = false
    }

    /// Called when the grid reaches the last item — loads the next cursor page.
    func loadNextPage() {
        guard hasNextPage, !isLoadingNextPage, !isSearching else { return }
        isLoadingNextPage = true
        Task {
            await performSearch(query: searchText, resetPagination: false)
            isLoadingNextPage = false
        }
    }

    func commitSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        repository.saveRecentSearch(trimmed)
        recentSearches = repository.fetchRecentSearches()
    }

    func selectRecentSearch(_ query: String) {
        searchText = query
    }

    func removeRecentSearch(_ query: String) {
        repository.removeRecentSearch(query)
        recentSearches = repository.fetchRecentSearches()
    }

    // MARK: - Filter Intents

    func showFilter() {
        pendingFilters = appliedFilters
        isFilterPresented = true
        Task { await loadFilterData() }
    }

    func applyFilters() {
        appliedFilters = pendingFilters
        isFilterPresented = false
        Task { await performSearch(query: searchText, resetPagination: true) }
    }

    func resetFilters() {
        pendingFilters = SearchFilters()
    }

    func toggleCategory(_ id: String) {
        pendingFilters.selectedCategoryIDs.formSymmetricDifference([id])
    }

    func toggleSubCategory(_ id: String) {
        pendingFilters.selectedSubCategoryIDs.formSymmetricDifference([id])
    }

    func toggleBrand(_ id: String) {
        pendingFilters.selectedBrandIDs.formSymmetricDifference([id])
    }

    func selectSort(_ option: SortOption) {
        pendingFilters.selectedSort = option
    }

    // MARK: - Filter Data Loading
    // Loads all three data sources concurrently.
    // Categories and brands reuse existing Home use cases — no duplicate network calls.

    private func loadFilterData() async {
        async let cats    = fetchCategoriesUseCase.execute().asyncValue()
        async let brands  = fetchBrandsUseCase.execute().asyncValue()
        async let subCats = fetchSubCategoriesUseCase.execute()

        do {
            let (categories, fetchedBrands, subCategories) = try await (cats, brands, subCats)
            filterCategories    = categories
            filterBrands        = processFilterBrands(fetchedBrands)
            filterSubCategories = subCategories
        } catch {
            // Non-fatal: filter sheet renders with whatever data loaded successfully
            errorMessage = error.localizedDescription
        }
    }

    /// Business rule: skip first 3 dummy collections; remove main category collections;
    /// sort remaining alphabetically.
    /// When Shopify adds a dedicated vendor/brand endpoint, replace only this method.
    private func processFilterBrands(_ brands: [BrandItem]) -> [BrandItem] {
        let mainCategories: Set<String> = ["MEN", "WOMEN", "KID", "KIDS", "SALE"]
        return brands
            .filter { !mainCategories.contains($0.name.uppercased()) }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
