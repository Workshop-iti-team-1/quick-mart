//
//  SearchViewModel.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Search State

    @Published var searchText: String = ""
    @Published private(set) var searchResults: [ProductSearchItem] = []
    @Published private(set) var recentSearches: [String] = []
    @Published private(set) var isSearching: Bool = false
    @Published private(set) var errorMessage: String? = nil

    // MARK: - Filter State

    /// Pending state — edited inside the sheet before Apply is tapped
    @Published var pendingFilters: SearchFilters = SearchFilters()
    /// Applied state — drives the actual search results
    @Published private(set) var appliedFilters: SearchFilters = SearchFilters()
    @Published var isFilterPresented: Bool = false

    // MARK: - Filter Data (loaded once when sheet opens)

    @Published private(set) var filterCategories: [CategoryItem] = []
    @Published private(set) var filterBrands: [BrandItem] = []
    @Published private(set) var filterSubCategories: [SubCategory] = []

    // MARK: - Computed

    var isSearchActive: Bool { !searchText.trimmingCharacters(in: .whitespaces).isEmpty }
    var hasResults: Bool { !searchResults.isEmpty }
    var hasActiveFilters: Bool { !appliedFilters.isEmpty }

    // MARK: - Dependencies

    private let searchProductsUseCase: SearchProductsUseCaseProtocol
    private let fetchSubCategoriesUseCase: FetchSubCategoriesUseCaseProtocol
    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol
    private let fetchBrandsUseCase: FetchBrandsUseCaseProtocol
    private let repository: SearchRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

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

    // MARK: - Setup

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                let trimmed = query.trimmingCharacters(in: .whitespaces)
                guard !trimmed.isEmpty else {
                    self.searchResults = []
                    return
                }
                Task { await self.performSearch(query: trimmed) }
            }
            .store(in: &cancellables)
    }

    // MARK: - Search Intents

    func performSearch(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isSearching = true
        errorMessage = nil
        do {
            searchResults = try await searchProductsUseCase.execute(
                query: trimmed,
                filters: appliedFilters
            )
        } catch {
            errorMessage = error.localizedDescription
            searchResults = []
        }
        isSearching = false
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
        pendingFilters = appliedFilters // Sync pending state before presenting
        isFilterPresented = true
        Task { await loadFilterData() }
    }

    func applyFilters() {
        appliedFilters = pendingFilters
        isFilterPresented = false
        guard !searchText.isEmpty else { return }
        Task { await performSearch(query: searchText) }
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

    private func loadFilterData() async {
        async let cats    = fetchCategoriesUseCase.execute()
        async let brands  = fetchBrandsUseCase.execute()
        async let subCats = fetchSubCategoriesUseCase.execute()

        do {
            let (c, b, s) = try await (cats, brands, subCats)
            filterCategories    = c
            filterBrands        = processFilterBrands(b)
            filterSubCategories = s
        } catch {
            // Non-fatal: filter sheet degrades gracefully with whatever data loaded
        }
    }

    /// Business rule: skip first 3 dummy collections; remove MEN/WOMEN/KID/SALE;
    /// sort remaining alphabetically. Maps to future Shopify collection metadata filtering.
    private func processFilterBrands(_ brands: [BrandItem]) -> [BrandItem] {
        let mainCategories: Set<String> = ["MEN", "WOMEN", "KID", "KIDS", "SALE"]
        return brands
            .dropFirst(3)
            .filter { !mainCategories.contains($0.name.uppercased()) }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
