//
//  DIContainer+Profile.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation

extension DIContainer {
    
    // MARK: - Profile / Orders
    private func makeProfileRemoteDataSource() -> ProfileRemoteDataSourceProtocol {
        ProfileRemoteDataSourceImpl(client: GraphQLClient(apollo: apolloClient))
    }
    
    private func makeProfileRepository() -> ProfileRepositoryProtocol {
        ProfileRepositoryImpl(remoteDataSource: makeProfileRemoteDataSource())
    }
    
     func makeGetCustomerOrdersUseCase() -> GetCustomerOrdersUseCaseProtocol {
        GetCustomerOrdersUseCase(repository: makeProfileRepository())
    }
    
    func makeOrderHistoryViewModel() -> OrderHistoryViewModel {
        OrderHistoryViewModel(getCustomerOrdersUseCase: makeGetCustomerOrdersUseCase())
    }
}
