//
//  RegisterRequestDTO.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

struct RegisterRequestDTO: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let acceptsMarketing: Bool
    
}
