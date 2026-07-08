//
//  AddressEventsBus.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressEventsBus.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


// Presentation/Address/AddressEventsBus.swift
// AddressEventsBus.swift

import Combine

final class AddressEventsBus {
    static let shared = AddressEventsBus()
    private init() {}

    let addressSaved = PassthroughSubject<Address, Never>()
    let addressDeleted = PassthroughSubject<String, Never>()
    let defaultAddressChanged = PassthroughSubject<String, Never>()
}
