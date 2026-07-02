//
//  HomeRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//

import Foundation
import Combine

final class HomeRepositoryImpl: HomeRepositoryProtocol {
    private let remoteDataSource: HomeRemoteDataSourceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(remoteDataSource: HomeRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    

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
    func fetchBrands() -> AnyPublisher<[BrandItem], Error> {
        remoteDataSource.fetchCollections(first: 20)
            .map { collections in
                collections
                    .dropFirst(3)
                    .dropLast(4)
                    .map { $0.toBrandEntity() }
            }
            .eraseToAnyPublisher()
    }

    func fetchCategories() -> AnyPublisher<[CategoryItem], Error> {
        remoteDataSource.fetchCollections(first: 20)
            .map { collections in
                collections
                    .suffix(4)
                    .map { $0.toCategoryEntity() }
            }
            .eraseToAnyPublisher()
    }
}
