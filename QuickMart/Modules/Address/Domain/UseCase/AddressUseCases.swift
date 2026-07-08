//
//  AddressUseCases.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressUseCases.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


// Domain/UseCases/AddressUseCases.swift
import Combine

protocol AddressUseCases {
    func fetchAddresses() -> AnyPublisher<[Address], Error>
    func addAddress(_ input: AddressInput) -> AnyPublisher<Address, Error>
    func updateAddress(id: String, input: AddressInput) -> AnyPublisher<Address, Error>
    func deleteAddress(id: String) -> AnyPublisher<String, Error>
    func setDefaultAddress(id: String) -> AnyPublisher<Address, Error>
}

struct AddressUseCasesImpl: AddressUseCases {
    let repository: AddressRepositoryProtocol

    func fetchAddresses() -> AnyPublisher<[Address], Error> {
        repository.fetchAddresses()
    }
    func addAddress(_ input: AddressInput) -> AnyPublisher<Address, Error> {
        repository.addAddress(input)
    }
    func updateAddress(id: String, input: AddressInput) -> AnyPublisher<Address, Error> {
        repository.updateAddress(id: id, input: input)
    }
    func deleteAddress(id: String) -> AnyPublisher<String, Error> {
        repository.deleteAddress(id: id)
    }
    func setDefaultAddress(id: String) -> AnyPublisher<Address, Error> {
        repository.setDefaultAddress(id: id)
    }
}
