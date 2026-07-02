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
                id: "gid://shopify/Product/8923761246406",
                name: "Nike Air Jordan Retro",
                price: 126.00,
                originalPrice: 156.00,
                imageName: "shoe",
                isSystemImage: true,
                colorNames: ["appBlack", "appBlue", "appBrown"],
                colorCount: 5
            ),
            ProductItem(
                id: "gid://shopify/Product/8923713994950",
                name: "Classic Black Glasses",
                price: 8.50,
                originalPrice: 10.00,
                imageName: "eyeglasses",
                isSystemImage: true,
                colorNames: ["appBlue", "grey100", "appBrown"],
                colorCount: 7
            ),
            ProductItem(
                id: "gid://shopify/Product/8923714027718",
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

    func getProductDetails(id: String) async throws -> ProductDetails {
        let productResponse = try await remoteDataSource.getProduct(id: id)
        
        let images = productResponse.images.edges.map { edge in
            ProductImage(id: edge.node.id ?? "", url: edge.node.url, altText: edge.node.altText)
        }
        
        let options = productResponse.options.map { option in
            ProductOption(id: option.id, name: option.name, values: option.values)
        }
        
        let variants = productResponse.variants.edges.map { edge in
            ProductDetailsVariant(
                id: edge.node.id,
                title: edge.node.title,
                availableForSale: edge.node.availableForSale,
                quantityAvailable: edge.node.quantityAvailable,
                price: Double(edge.node.price.amount) ?? 0.0,
                currencyCode: edge.node.price.currencyCode.rawValue,
                compareAtPrice: edge.node.compareAtPrice.flatMap { Double($0.amount) },
                selectedOptions: edge.node.selectedOptions.map { SelectedOption(name: $0.name, value: $0.value) },
                imageURL: edge.node.image?.url
            )
        }
        
        var rating: Double = 0.0
        var reviewsCount: Int = 0
        
        for metafield in productResponse.metafields.compactMap({ $0 }) {
            if metafield.key == "rating", let val = Double(metafield.value) {
                rating = val
            } else if metafield.key == "rating_count", let val = Int(metafield.value) {
                reviewsCount = val
            }
        }
        
        return ProductDetails(
            id: productResponse.id,
            title: productResponse.title,
            description: productResponse.descriptionHtml,
            vendor: productResponse.vendor,
            productType: productResponse.productType,
            tags: productResponse.tags,
            availableForSale: productResponse.availableForSale,
            minPrice: Double(productResponse.priceRange.minVariantPrice.amount) ?? 0.0,
            maxPrice: Double(productResponse.priceRange.maxVariantPrice.amount) ?? 0.0,
            currencyCode: productResponse.priceRange.minVariantPrice.currencyCode.rawValue,
            compareAtPrice: Double(productResponse.compareAtPriceRange.minVariantPrice.amount),
            images: images,
            options: options,
            variants: variants,
            rating: rating,
            reviewsCount: reviewsCount
        )
    }
}
