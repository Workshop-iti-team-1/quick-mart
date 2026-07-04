//
//  BannerItem.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import Foundation

struct BannerItem: Identifiable, Hashable {
    let id: String
    let discount: String
    let subtitle: String
    let title: String
    let code: String
    let imageName: String
    let isSystemImage: Bool
    let gradientStart: String
    let gradientEnd: String
}

