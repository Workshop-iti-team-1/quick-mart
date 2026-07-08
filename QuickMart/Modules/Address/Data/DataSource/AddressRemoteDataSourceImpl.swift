//
//  AddressRemoteDataSourceImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressRemoteDataSourceImpl.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//

import Combine
import ApolloAPI

final class AddressRemoteDataSourceImpl: AddressRemoteDataSourceProtocol {
    private let client: ShopifyGraphQLClientProtocol
    init(client: ShopifyGraphQLClientProtocol) { self.client = client }

    func fetchAddresses(accessToken: String) -> AnyPublisher<[Address], Error> {
        Future { [client] promise in
            Task {
                do {
                    let query = ShopifyAPI.CustomerAddressesQuery(customerAccessToken: accessToken)
                    let data = try await client.performQuery(query: query, cachePolicy: .fetchIgnoringCacheData)
                    guard let customer = data.customer else {
                        promise(.success([]))
                        return
                    }
                    let defaultId = customer.defaultAddress?.id
                    let addresses = customer.addresses.edges.map { edge -> Address in
                        let dto = AddressModel(from: edge.node)
                        return dto.toEntity(isDefault: dto.id == defaultId)
                    }
                    promise(.success(addresses))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func createAddress(accessToken: String, input: AddressInput) -> AnyPublisher<Address, Error> {
        Future { [client] promise in
            Task {
                do {
                    let mutation = ShopifyAPI.AddCustomerAddressMutation(
                        customerAccessToken: accessToken, address: input.toMailingAddressInput())
                    let data = try await client.performMutation(mutation: mutation)
                    guard let result = data.customerAddressCreate else { throw AddressError.unknown }
                    if let err = result.customerUserErrors.first { throw AddressError.server(err.message) }
                    guard let address = result.customerAddress else { throw AddressError.unknown }
                    promise(.success(AddressModel(from: address).toEntity()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func updateAddress(accessToken: String, id: String, input: AddressInput) -> AnyPublisher<Address, Error> {
        Future { [client] promise in
            Task {
                do {
                    let mutation = ShopifyAPI.UpdateCustomerAddressMutation(
                        customerAccessToken: accessToken, id: id, address: input.toMailingAddressInput())
                    let data = try await client.performMutation(mutation: mutation)
                    guard let result = data.customerAddressUpdate else { throw AddressError.unknown }
                    if let err = result.customerUserErrors.first { throw AddressError.server(err.message) }
                    guard let address = result.customerAddress else { throw AddressError.unknown }
                    promise(.success(AddressModel(from: address).toEntity()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func deleteAddress(accessToken: String, id: String) -> AnyPublisher<String, Error> {
        Future { [client] promise in
            Task {
                do {
                    let mutation = ShopifyAPI.DeleteCustomerAddressMutation(customerAccessToken: accessToken, id: id)
                    let data = try await client.performMutation(mutation: mutation)
                    guard let result = data.customerAddressDelete else { throw AddressError.unknown }
                    if let err = result.customerUserErrors.first { throw AddressError.server(err.message) }
                    guard let deletedId = result.deletedCustomerAddressId else { throw AddressError.unknown }
                    promise(.success(deletedId))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func setDefaultAddress(accessToken: String, id: String) -> AnyPublisher<Address, Error> {
        Future { [client] promise in
            Task {
                do {
                    let mutation = ShopifyAPI.SetDefaultAddressMutation(customerAccessToken: accessToken, addressId: id)
                    let data = try await client.performMutation(mutation: mutation)
                    guard let result = data.customerDefaultAddressUpdate else { throw AddressError.unknown }
                    if let err = result.customerUserErrors.first { throw AddressError.server(err.message) }
                    guard let address = result.customer?.defaultAddress else { throw AddressError.unknown }
                    promise(.success(AddressModel(from: address).toEntity(isDefault: true)))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
