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
    case shippingAddresses
    case addressForm(Address?)
    case favoriteDetail(ProductDetails)
    case wishlist
    case profile
    case shippingAddress
    case paymentMethod
    case orderHistory
    case privacyPolicy
    case termsAndConditions
    case faqs
    case changePassword
}
