//
//  TabItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import Foundation

enum TabItem: Int, CaseIterable {
    case home
    case wishlist
    case search
    case cart
    case profile

    var title: String {
        switch self {
        case .home:     return "Home"
        case .wishlist: return "Wishlist"
        case .search:   return "Search"
        case .cart:     return "My Cart"
        case .profile:  return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home:     return "house.fill"
        case .wishlist: return "heart"
        case .search:   return "magnifyingglass"
        case .cart:     return "cart"
        case .profile:  return "person"
        }
    }
}
