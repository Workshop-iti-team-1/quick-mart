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
    private let discountDataSource: DiscountDataSourceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
         remoteDataSource: HomeRemoteDataSourceProtocol,
         discountDataSource: DiscountDataSourceProtocol
     ) {
         self.remoteDataSource = remoteDataSource
         self.discountDataSource = discountDataSource
     }

    

    func fetchBanners() async throws -> [BannerItem] {
          let discounts = try await discountDataSource.fetchActiveDiscounts()
          return discounts.enumerated().map { $0.element.toBannerItem(index: $0.offset) }
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

