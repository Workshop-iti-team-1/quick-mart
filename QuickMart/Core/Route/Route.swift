//
//  Route.swift
//  QuickMart
//

import Foundation

enum Route: Hashable {
    case home
    case login
    case signup
    case category
    case forgotPassword
    case allBrands
    case categoryDetail(CategoryItem)
    case productDetails(productId: String)
    case cart
    case search(filters: SearchFilters? = nil)
}
