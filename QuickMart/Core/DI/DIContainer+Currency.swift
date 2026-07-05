//
//  DIContainer+Currency.swift
//  QuickMart
//
//  Created by siam on 05/07/2026.
//

extension DIContainer {
    private var currencyRemoteDataSource: CurrencyRemoteDataSourceProtocol {
        CurrencyRemoteDataSource(client: restClient)
    }
    
    private var currencyRepository: CurrencyRepositoryProtocol {
        CurrencyRepositoryImpl(remoteDataSource: currencyRemoteDataSource)
    }
    
    private var getCurrencyRatesUseCase: GetCurrencyRatesUseCaseProtocol {
        GetCurrencyRatesUseCase(repository: currencyRepository)
    }
    
    func makeCurrencyManagerService() -> CurrencyManagerSrevice {
        CurrencyManagerSrevice(getRatesUseCase: getCurrencyRatesUseCase)
    }
}
