//
//  CountryRemoteDataSourceImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  CountryRemoteDataSourceImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//

import Foundation
import Combine

final class CountryRemoteDataSourceImpl: CountryRemoteDataSourceProtocol {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func fetchCountries() -> AnyPublisher<[Country], Error> {
        guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CountriesResponseModel.self, decoder: JSONDecoder())
            .map { response in response.data.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
}
