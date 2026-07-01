//
//  MockCategoryRepository.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 29/06/2026.
//
// Features/Category/Data/MockCategoryRepository.swift

import Foundation

// MARK: - Protocol (Dependency Inversion – SOLID)

protocol CategoryRepositoryProtocol {
    func fetchCategories() -> [CategoryItem]
}

// MARK: - Mock Implementation

struct MockCategoryRepository: CategoryRepositoryProtocol {

    func fetchCategories() -> [CategoryItem] {
        [
            CategoryItem(id: "1",  name: "Electronics",             imageName: "desktopcomputer",        isSystemImage: true),
            CategoryItem(id: "2",  name: "Fashion",                 imageName: "bag.fill",               isSystemImage: true),
            CategoryItem(id: "3",  name: "Furniture",               imageName: "sofa.fill",              isSystemImage: true),
            CategoryItem(id: "4",  name: "Industrial",              imageName: "car.fill",               isSystemImage: true),
            CategoryItem(id: "5",  name: "Home Decor",              imageName: "gift.fill",              isSystemImage: true),
            CategoryItem(id: "6",  name: "Electronics",             imageName: "tv.fill",                isSystemImage: true),
            CategoryItem(id: "7",  name: "Health",                  imageName: "stethoscope",            isSystemImage: true),
            CategoryItem(id: "8",  name: "Construction & Real State",imageName: "house.fill",             isSystemImage: true),
            CategoryItem(id: "9",  name: "Fabrication Service",     imageName: "wrench.and.screwdriver.fill", isSystemImage: true),
            CategoryItem(id: "10", name: "Electrical Equipment",    imageName: "bolt.fill",              isSystemImage: true),
        ]
    }
}
