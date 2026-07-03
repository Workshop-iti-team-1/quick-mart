//
//  SearchFilters.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import Foundation

/// Complete filter + sort state for a search query.
///
/// Shopify GraphQL mapping:
/// - selectedCategoryIDs   → collection handles passed to `collections` query
/// - selectedSubCategoryIDs → `productTypes` filter array
/// - selectedBrandIDs      → `vendor` filter array
/// - selectedSort          → `sortKey` + `reverse` on products query
struct SearchFilters: Equatable, Hashable {

    // MARK: - State (OR within section, AND across sections)

    var selectedCategoryIDs: Set<String>    = []
    var selectedSubCategoryIDs: Set<String> = []
    var selectedBrandIDs: Set<String>       = []
    var selectedSort: SortOption            = .featured

    // MARK: - Computed

    var isEmpty: Bool {
        selectedCategoryIDs.isEmpty
            && selectedSubCategoryIDs.isEmpty
            && selectedBrandIDs.isEmpty
            && selectedSort == .featured
    }

    /// Drives the filter badge count on the search bar icon
    var activeFilterCount: Int {
        var count = 0
        if !selectedCategoryIDs.isEmpty    { count += 1 }
        if !selectedSubCategoryIDs.isEmpty { count += 1 }
        if !selectedBrandIDs.isEmpty       { count += 1 }
        if selectedSort != .featured       { count += 1 }
        return count
    }
}
