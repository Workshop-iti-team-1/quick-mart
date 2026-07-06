//
//  CurrencyItem.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//
import Foundation

struct CurrencyItem: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    let flag: String
}


