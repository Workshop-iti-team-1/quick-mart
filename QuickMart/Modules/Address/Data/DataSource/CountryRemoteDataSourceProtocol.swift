//
//  CountryRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  CountryRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


// Data/DataSources/CountryRemoteDataSource.swift
import Foundation
import Combine

protocol CountryRemoteDataSourceProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}
