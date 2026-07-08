//
//  Apollo+NetworkError.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation
import Apollo
import ApolloAPI

extension NetworkError {

    static func from(_ apolloError: Error) -> NetworkError {

        if let error = apolloError as? Apollo.ResponseCodeInterceptor.ResponseCodeError {
            switch error {
            case .invalidResponseCode(let response, let data):
                switch response?.statusCode {
                case 401: return .unauthorized
                case 429: return .rateLimited
                case let code?: return .requestFailed(statusCode: code, data: data)
                default:  return .requestFailed(statusCode: 0, data: data)
                }
            }
        }

        return .requestFailed(statusCode: 0, data: nil)
    }

    static func from(shopifyErrors: [ShopifyUserError]) -> NetworkError {
        return .userErrors(shopifyErrors)
    }
}
