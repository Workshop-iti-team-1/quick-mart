//
//  CountryMapper.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


import Foundation

extension CountryModel{
    func toEntity() -> Country {
        Country(name: country, iso2: iso2 ?? "", cities: cities.sorted())
    }
}
