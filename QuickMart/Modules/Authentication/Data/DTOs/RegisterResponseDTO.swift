//
//  RegisterResponseDTO.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation


struct CustomerDTO: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let email: String
    
    func toDomain() -> Customer {
        return Customer(id: id, firstName: firstName ?? "", lastName: lastName ?? "", email: email)
    }
}
