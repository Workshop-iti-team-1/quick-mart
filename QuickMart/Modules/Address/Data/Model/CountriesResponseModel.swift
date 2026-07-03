//
//  CountriesResponseModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  CountryModel.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//

// Data/DTOs/CountryDTO.swift
import Foundation

struct CountriesResponseModel: Decodable {
    let error: Bool
    let msg: String
    let data: [CountryModel]
}

struct CountryModel: Decodable {
    let country: String
    let iso2: String?
    let iso3: String?
    let cities: [String]
}
