//
//  Address.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  Address.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//


// Domain/Models/Address.swift
import Foundation

struct Address: Identifiable, Hashable {
    let id: String
    let firstName: String?
    let lastName: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    var isDefault: Bool = false

    var fullName: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }

    var formattedAddress: String {
        [address1, address2, city, province, zip, country]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

struct AddressInput {
    var firstName: String
    var lastName: String
    var address1: String
    var address2: String
    var city: String
    var province: String
    var country: String
    var zip: String
    var phone: String
}

enum AddressError: LocalizedError {
    case server(String)
    case unauthenticated
    case unknown

    var errorDescription: String? {
        switch self {
        case .server(let message): return message
        case .unauthenticated: return "You need to be logged in to manage addresses."
        case .unknown: return "Something went wrong. Please try again."
        }
    }
}
