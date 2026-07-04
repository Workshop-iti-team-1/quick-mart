//
//  FetchCountriesUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  FetchCountriesUseCaseProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


// Domain/UseCases/FetchCountriesUseCase.swift
import Combine

protocol FetchCountriesUseCaseProtocol {
    func execute() -> AnyPublisher<[Country], Error>
}

struct FetchCountriesUseCase: FetchCountriesUseCaseProtocol {
    let repository: CountryRepositoryProtocol
    func execute() -> AnyPublisher<[Country], Error> {
        repository.fetchCountries()
    }
}
