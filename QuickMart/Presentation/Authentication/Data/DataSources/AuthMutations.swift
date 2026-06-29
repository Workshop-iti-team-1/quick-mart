//
//  AuthMutations.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

enum AuthMutations {
    static let register = """
    mutation RegisterCustomer($input: CustomerCreateInput!) {
      customerCreate(input: $input) {
        customer {
          id
          firstName
          lastName
          email
        }
        customerUserErrors { code field message }
      }
    }
    """
    
    static let login = """
    mutation LoginCustomer($input: CustomerAccessTokenCreateInput!) {
      customerAccessTokenCreate(input: $input) {
        customerAccessToken {
          accessToken
          expiresAt
        }
        customerUserErrors { code field message }
      }
    }
    """
}
