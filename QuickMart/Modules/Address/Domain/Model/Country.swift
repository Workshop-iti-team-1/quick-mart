//
//  Country.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  Country.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


// Domain/Models/Country.swift
import Foundation

struct Country: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let iso2: String
    let cities: [String]
}
