//
//  HomeRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import Foundation
import Combine

protocol HomeRepositoryProtocol {
    func fetchBanners() -> [BannerItem]
    func fetchBrands() -> AnyPublisher<[BrandItem], Error>
    func fetchCategories() -> AnyPublisher<[CategoryItem], Error>
    func getProductDetails(id: String) async throws -> ProductDetails
}
