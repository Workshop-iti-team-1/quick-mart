//
//  RootViewModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 01/07/2026.
//


import Foundation

@MainActor
final class RootViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .home
    @Published var cartItemCount: Int = 3

    func select(_ tab: TabItem) {
        selectedTab = tab
    }
}