//
//  NetworkError.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

public struct GraphQLError: Codable, LocalizedError {
    public let message: String
    public let locations: [Location]?
    public let path: [String]?

    public struct Location: Codable {
        public let line: Int
        public let column: Int
    }

    public var errorDescription: String? { message }
}

public struct ShopifyUserError: Codable {
    public let code: String?
    public let field: [String]?
    public let message: String

    public var fieldPath: String { field?.joined(separator: ".") ?? "" }
}

public enum NetworkError: LocalizedError {

    case invalidURL
    case encodingFailed(Error)
    case requestFailed(statusCode: Int, data: Data?)
    case decodingFailed(Error)
    case graphQLErrors([GraphQLError])
    case userErrors([ShopifyUserError])
    case noData
    case unauthorized
    case rateLimited

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return AppStrings.Network.invalidURL
        case .encodingFailed(let e):
            return AppStrings.Network.encodingFailed(e.localizedDescription)
        case .requestFailed(let code, _):
            return AppStrings.Network.requestFailed(code)
        case .decodingFailed(let e):
            return AppStrings.Network.decodingFailed(e.localizedDescription)
        case .graphQLErrors(let errs):
            return errs.map(\.message).joined(separator: "; ")
        case .userErrors(let errs):
            return errs.map(\.message).joined(separator: "; ")
        case .noData:
            return AppStrings.Network.noData
        case .unauthorized:
            return AppStrings.Network.unauthorized
        case .rateLimited:
            return AppStrings.Network.rateLimited
        }
    }
}
