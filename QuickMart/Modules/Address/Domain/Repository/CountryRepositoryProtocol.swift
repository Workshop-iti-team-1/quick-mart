//
//  CountryRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  CountryRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//



import Combine

protocol CountryRepositoryProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}

