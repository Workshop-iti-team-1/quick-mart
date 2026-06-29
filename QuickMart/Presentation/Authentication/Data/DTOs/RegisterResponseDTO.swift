//
//  RegisterResponseDTO.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

struct RegisterResponse: Decodable {
    let data: RegisterData
}
struct RegisterData: Decodable {
    let customerCreate: CustomerCreate
}
struct CustomerCreate: Decodable {
    let customer: CustomerDTO?
    let customerUserErrors: [ShopifyUserError]
}
struct CustomerDTO: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let email: String
    
    func toDomain() -> Customer {
        return Customer(id: id, firstName: firstName ?? "", lastName: lastName ?? "", email: email)
    }
}
