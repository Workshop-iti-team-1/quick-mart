//
//  TabItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import Foundation

enum TabItem: Int, CaseIterable {
    case home
    case search
    case cart
    case wishlist
    case profile

    var title: String {
        switch self {
        case .home:     return "Home"
        case .search:   return "Search"
        case .cart:     return "My Cart"
        case .wishlist: return "Wishlist"
        case .profile:  return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home:     return "house.fill"
        case .search:   return "magnifyingglass"
        case .cart:     return "cart"
        case .wishlist: return "heart"
        case .profile:  return "person"
        }
    }
}