//
//  CountryDataProvider.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  CountryDataProvider.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


// Presentation/Address/CountryDataProvider.swift
import Combine
import Foundation

@MainActor
final class CountryDataProvider: ObservableObject {
    @Published private(set) var countries: [Country] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let fetchCountriesUseCase: FetchCountriesUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var hasLoaded = false

    init(fetchCountriesUseCase: FetchCountriesUseCaseProtocol) {
        self.fetchCountriesUseCase = fetchCountriesUseCase
    }

    func loadIfNeeded() {
        guard !hasLoaded, !isLoading else { return }
        isLoading = true
        fetchCountriesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries.sorted { $0.name < $1.name }
                self?.hasLoaded = true
            }
            .store(in: &cancellables)
    }

    var countryNames: [String] { countries.map { $0.name } }

    func cities(for countryName: String) -> [String] {
        countries.first(where: { $0.name == countryName })?.cities ?? []
    }
}
