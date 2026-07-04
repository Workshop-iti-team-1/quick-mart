//
//  AddressRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressRepositoryProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


// Domain/Repositories/AddressRepositoryProtocol.swift
import Combine

protocol AddressRepositoryProtocol {
    func fetchAddresses() -> AnyPublisher<[Address], Error>
    func addAddress(_ input: AddressInput) -> AnyPublisher<Address, Error>
    func updateAddress(id: String, input: AddressInput) -> AnyPublisher<Address, Error>
    func deleteAddress(id: String) -> AnyPublisher<String, Error>
    func setDefaultAddress(id: String) -> AnyPublisher<Address, Error>
}
