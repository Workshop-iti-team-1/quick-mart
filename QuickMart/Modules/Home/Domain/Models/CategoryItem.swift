//
//  CategoryItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


// Features/Category/Domain/Models/CategoryItem.swift
import Foundation

struct CategoryItem: Identifiable, Hashable {
    let id: String
    let name: String
    let imageName: String
    let isSystemImage: Bool
}