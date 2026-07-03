//
//  AddressRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressRepositoryImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


// Data/Repositories/AddressRepositoryImpl.swift
import Combine

final class AddressRepositoryImpl: AddressRepositoryProtocol {
    private let remoteDataSource: AddressRemoteDataSourceProtocol
    private let sessionManager: SessionManager

    init(remoteDataSource: AddressRemoteDataSourceProtocol, sessionManager: SessionManager = .shared) {
        self.remoteDataSource = remoteDataSource
        self.sessionManager = sessionManager
    }

    private func requireToken() -> AnyPublisher<String, Error> {
        guard let token = sessionManager.getToken() else {
            return Fail(error: AddressError.unauthenticated).eraseToAnyPublisher()
        }
        return Just(token).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func fetchAddresses() -> AnyPublisher<[Address], Error> {
        requireToken().flatMap { [remoteDataSource] in remoteDataSource.fetchAddresses(accessToken: $0) }.eraseToAnyPublisher()
    }
    func addAddress(_ input: AddressInput) -> AnyPublisher<Address, Error> {
        requireToken().flatMap { [remoteDataSource] in remoteDataSource.createAddress(accessToken: $0, input: input) }.eraseToAnyPublisher()
    }
    func updateAddress(id: String, input: AddressInput) -> AnyPublisher<Address, Error> {
        requireToken().flatMap { [remoteDataSource] in remoteDataSource.updateAddress(accessToken: $0, id: id, input: input) }.eraseToAnyPublisher()
    }
    func deleteAddress(id: String) -> AnyPublisher<String, Error> {
        requireToken().flatMap { [remoteDataSource] in remoteDataSource.deleteAddress(accessToken: $0, id: id) }.eraseToAnyPublisher()
    }
    func setDefaultAddress(id: String) -> AnyPublisher<Address, Error> {
        requireToken().flatMap { [remoteDataSource] in remoteDataSource.setDefaultAddress(accessToken: $0, id: id) }.eraseToAnyPublisher()
    }
}
