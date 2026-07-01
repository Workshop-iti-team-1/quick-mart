//
//  CategoryRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//

import Foundation
protocol CategoryRepositoryProtocol {
    func fetchCategories() -> [CategoryItem]
}
