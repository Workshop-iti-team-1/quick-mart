//
//  CountryRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  CountryRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//

import Combine
final class CountryRepositoryImpl: CountryRepositoryProtocol {
    private let remoteDataSource: CountryRemoteDataSourceProtocol
    init(remoteDataSource: CountryRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        remoteDataSource.fetchCountries()
    }
}
