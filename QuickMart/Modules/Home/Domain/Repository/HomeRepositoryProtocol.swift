//
//  HomeRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import Foundation

protocol HomeRepositoryProtocol {
    func fetchBanners() -> [BannerItem]
    func fetchLatestProducts() -> [ProductItem]
    func fetchBrands() -> [BrandItem]
    func fetchCategories() -> [CategoryItem]
    
}
