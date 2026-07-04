//
//  SearchFilterBottomSheet.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 02/07/2026.
//

import SwiftUI

struct SearchFilterBottomSheet: View {

    @ObservedObject var viewModel: SearchViewModel

    // Each section tracks its own expansion independently
    @State private var isCategoriesExpanded: Bool = true
    @State private var isSubCategoriesExpanded: Bool = false
    @State private var isBrandsExpanded: Bool = false
    @State private var isSortExpanded: Bool = true

    private enum Layout {
        static let horizontalPad: CGFloat = 16
        static let applyHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 12
        static let headerTopPad: CGFloat = 20
    }

    var body: some View {
        VStack(spacing: 0) {
            sheetHeader
            Divider()
            filterSections
            applyButton
        }
        .background(Color.backGround)
    }

    // MARK: - Header

    private var sheetHeader: some View {
        HStack {
            Text("Filter")
                .appTextStyle(.heading2, color: .appBlack)
            Spacer()
            if !viewModel.pendingFilters.isEmpty {
                Button("Reset") {
                    viewModel.resetFilters()
                }
                .appTextStyle(.label, color: .cyanPrimary)
            }
        }
        .padding(.horizontal, Layout.horizontalPad)
        .padding(.top, Layout.headerTopPad)
        .padding(.bottom, 12)
    }

    // MARK: - Filter Sections

    private var filterSections: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                categoriesSection
                subCategoriesSection
                brandsSection
                sortSection
            }
            .padding(.horizontal, Layout.horizontalPad)
        }
    }

    // MARK: - Categories
    private var categoriesSection: some View {
        CollapsibleFilterSection(
            title: "Categories",
            isExpanded: $isCategoriesExpanded,
            selectedCount: viewModel.pendingFilters.selectedCategoryIDs.count
        ) {
            ForEach(viewModel.filterCategories) { category in
                let key = category.handle ?? category.id
                CheckboxRowView(
                    title: category.name.uppercased(),
                    isSelected: viewModel.pendingFilters.selectedCategoryIDs
                        .contains(key)
                ) {
                    viewModel.toggleCategory(key)
                }
            }
        }
    }

    // MARK: - Brands
    private var brandsSection: some View {
        CollapsibleFilterSection(
            title: "Brands",
            isExpanded: $isBrandsExpanded,
            selectedCount: viewModel.pendingFilters.selectedBrandIDs.count
        ) {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16),
                ],
                alignment: .leading,
                spacing: 12
            ) {
                ForEach(viewModel.filterBrands) { brand in
                    CheckboxRowView(
                        title: brand.name.uppercased(),
                        isSelected: viewModel.pendingFilters.selectedBrandIDs
                            .contains(brand.name)
                    ) {
                        viewModel.toggleBrand(brand.name)
                    }
                }
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Sub-Categories

    private var subCategoriesSection: some View {
        CollapsibleFilterSection(
            title: "Sub-Categories",
            isExpanded: $isSubCategoriesExpanded,
            selectedCount: viewModel.pendingFilters.selectedSubCategoryIDs.count
        ) {
            ForEach(viewModel.filterSubCategories) { sub in
                CheckboxRowView(
                    title: sub.name,
                    isSelected: viewModel.pendingFilters.selectedSubCategoryIDs
                        .contains(sub.id)
                ) {
                    viewModel.toggleSubCategory(sub.id)
                }
            }
        }
    }

    //    // MARK: - Brands
    //
    //    private var brandsSection: some View {
    //        CollapsibleFilterSection(
    //            title: "Brands",
    //            isExpanded: $isBrandsExpanded,
    //            selectedCount: viewModel.pendingFilters.selectedBrandIDs.count
    //        ) {
    //            ForEach(viewModel.filterBrands) { brand in
    //                CheckboxRowView(
    //                    title: brand.name.uppercased(),
    //                    isSelected: viewModel.pendingFilters.selectedBrandIDs
    //                        .contains(brand.id)
    //                ) {
    //                    viewModel.toggleBrand(brand.id)
    //                }
    //            }
    //        }
    //    }

    // MARK: - Sorting (single-select enforced by ViewModel)

    private var sortSection: some View {
        CollapsibleFilterSection(
            title: "Sorting",
            isExpanded: $isSortExpanded,
            selectedCount: viewModel.pendingFilters.selectedSort != .featured
                ? 1 : 0
        ) {
            ForEach(SortOption.allCases) { option in
                CheckboxRowView(
                    title: option.rawValue,
                    isSelected: viewModel.pendingFilters.selectedSort == option
                ) {
                    viewModel.selectSort(option)
                }
            }
        }
    }

    // MARK: - Apply Button

    private var applyButton: some View {
        Button {
            viewModel.applyFilters()
        } label: {
            Text("Apply")
                .appTextStyle(.button, color: .appWhite)
                .frame(maxWidth: .infinity)
                .frame(height: Layout.applyHeight)
                .background(Color.appBlack)
                .cornerRadius(Layout.cornerRadius)
        }
        .padding(.horizontal, Layout.horizontalPad)
        .padding(.vertical, 16)
    }
}

//#Preview {
//    let vm = SearchViewModel(
//        searchProductsUseCase: SearchProductsUseCase(repository: MockSearchRepository()),
//        fetchSubCategoriesUseCase: FetchSubCategoriesUseCase(repository: MockSearchRepository()),
//        fetchCategoriesUseCase: FetchCategoriesUseCase(repository: MockHomeRepository()),
//        fetchBrandsUseCase: FetchBrandsUseCase(repository: MockHomeRepository()),
//        repository: MockSearchRepository()
//    )
//    SearchFilterBottomSheet(viewModel: vm)
//}
