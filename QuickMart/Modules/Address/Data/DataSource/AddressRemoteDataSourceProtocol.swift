//
//  AddressRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//



import Combine
import Foundation



protocol AddressRemoteDataSourceProtocol {
    func fetchAddresses(accessToken: String) -> AnyPublisher<[Address], Error>
    func createAddress(accessToken: String, input: AddressInput) -> AnyPublisher<Address, Error>
    func updateAddress(accessToken: String, id: String, input: AddressInput) -> AnyPublisher<Address, Error>
    func deleteAddress(accessToken: String, id: String) -> AnyPublisher<String, Error>
    func setDefaultAddress(accessToken: String, id: String) -> AnyPublisher<Address, Error>
}

