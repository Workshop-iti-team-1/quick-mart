//
//  MockHomeRepository.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import Foundation

struct MockHomeRepository: HomeRepositoryProtocol {

    func fetchBanners() -> [BannerItem] {
        [
            BannerItem(
                id: "1",
                discount: "30% OFF",
                subtitle: "On Headphones",
                title: "Exclusive Sales",
                imageName: "headphones",
                isSystemImage: true,
                gradientStart: "appBlue",
                gradientEnd: "cyanPrimary"
            ),
            BannerItem(
                id: "2",
                discount: "20% OFF",
                subtitle: "On Sneakers",
                title: "Fresh Drops",
                imageName: "shoe",
                isSystemImage: true,
                gradientStart: "appPurple",
                gradientEnd: "appPink"
            ),
            BannerItem(
                id: "3",
                discount: "15% OFF",
                subtitle: "On Eyewear",
                title: "Style Up",
                imageName: "eyeglasses",
                isSystemImage: true,
                gradientStart: "appMerigold",
                gradientEnd: "appOrange"
            ),
        ]
    }

    func fetchLatestProducts() -> [ProductItem] {
        [
            ProductItem(
                id: "1",
                name: "Nike Air Jordan Retro",
                price: 126.00,
                originalPrice: 156.00,
                imageName: "shoe",
                isSystemImage: true,
                colorNames: ["appBlack", "appBlue", "appBrown"],
                colorCount: 5
            ),
            ProductItem(
                id: "2",
                name: "Classic Black Glasses",
                price: 8.50,
                originalPrice: 10.00,
                imageName: "eyeglasses",
                isSystemImage: true,
                colorNames: ["appBlue", "grey100", "appBrown"],
                colorCount: 7
            ),
            ProductItem(
                id: "3",
                name: "Wireless Earbuds Pro",
                price: 49.99,
                originalPrice: 69.99,
                imageName: "headphones",
                isSystemImage: true,
                colorNames: ["appBlack", "appWhite"],
                colorCount: 3
            ),
            ProductItem(
                id: "4",
                name: "Leather Handbag",
                price: 89.00,
                originalPrice: nil,
                imageName: "bag.fill",
                isSystemImage: true,
                colorNames: ["appBrown", "appBlack"],
                colorCount: 4
            ),
        ]
    }
    
    // MARK: - Updated Categories to use Custom Images
    func fetchCategories() -> [CategoryItem] {
        [
            CategoryItem(
                id: "1", name: "WOMEN", imageName: "women",
                isSystemImage: false),
            CategoryItem(
                id: "2", name: "MEN", imageName: "men",
                isSystemImage: false),
            CategoryItem(
                id: "3", name: "SALE", imageName: "sale",
                isSystemImage: false),
            CategoryItem(
                id: "4", name: "KID", imageName: "kid",
                isSystemImage: false),
        ]
    }
    
    func fetchBrands() -> [BrandItem] {
        [
            BrandItem(id: "1",  name: "Electronics",              imageName: "desktopcomputer",             isSystemImage: true),
            BrandItem(id: "2",  name: "Fashion",                  imageName: "bag.fill",                    isSystemImage: true),
            BrandItem(id: "3",  name: "Furniture",                imageName: "sofa.fill",                   isSystemImage: true),
            BrandItem(id: "4",  name: "Industrial",               imageName: "car.fill",                    isSystemImage: true),
            BrandItem(id: "5",  name: "Home Decor",               imageName: "gift.fill",                   isSystemImage: true),
            BrandItem(id: "6",  name: "Health",                   imageName: "stethoscope",                 isSystemImage: true),
            BrandItem(id: "7",  name: "Construction",             imageName: "house.fill",                  isSystemImage: true),
            BrandItem(id: "8",  name: "Electrical Equipment",     imageName: "bolt.fill",                   isSystemImage: true),
        ]
    }
}
