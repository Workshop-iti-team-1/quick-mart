//
//  AddressMapper.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


import Foundation

// MARK: - Response mapping: generated types → AddressDTO

extension AddressModel {
    init(from node: ShopifyAPI.CustomerAddressesQuery.Data.Customer.Addresses.Edge.Node) {
        self.init(id: node.id, firstName: node.firstName, lastName: node.lastName,
                   address1: node.address1, address2: node.address2, city: node.city,
                   province: node.province, country: node.country, zip: node.zip, phone: node.phone)
    }

    init(from address: ShopifyAPI.AddCustomerAddressMutation.Data.CustomerAddressCreate.CustomerAddress) {
        self.init(id: address.id, firstName: address.firstName, lastName: address.lastName,
                   address1: address.address1, address2: address.address2, city: address.city,
                   province: address.province, country: address.country, zip: address.zip, phone: address.phone)
    }

    init(from address: ShopifyAPI.UpdateCustomerAddressMutation.Data.CustomerAddressUpdate.CustomerAddress) {
        self.init(id: address.id, firstName: address.firstName, lastName: address.lastName,
                   address1: address.address1, address2: address.address2, city: address.city,
                   province: address.province, country: address.country, zip: address.zip, phone: address.phone)
    }

    init(from address: ShopifyAPI.SetDefaultAddressMutation.Data.CustomerDefaultAddressUpdate.Customer.DefaultAddress) {
        self.init(id: address.id, firstName: address.firstName, lastName: address.lastName,
                   address1: address.address1, address2: address.address2, city: address.city,
                   province: address.province, country: address.country, zip: address.zip, phone: address.phone)
    }
}

// MARK: - DTO → Domain

extension AddressModel {
    func toEntity(isDefault: Bool = false) -> Address {
        Address(id: id, firstName: firstName, lastName: lastName, address1: address1,
                address2: address2, city: city, province: province, country: country,
                zip: zip, phone: phone, isDefault: isDefault)
    }
}

// MARK: - Domain → Request (AddressInput → generated MailingAddressInput)

extension AddressInput {
    func toMailingAddressInput() -> ShopifyAPI.MailingAddressInput {
        // Verify field wrapping (.some(...) vs plain) against your actual generated MailingAddressInput
        ShopifyAPI.MailingAddressInput(
            address1: .some(address1), address2: .some(address2), city: .some(city),
            country: .some(country), firstName: .some(firstName), lastName: .some(lastName),
            phone: .some(phone), province: .some(province), zip: .some(zip)
        )
    }
}
