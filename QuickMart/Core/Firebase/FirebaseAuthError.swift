//
//  FirebaseAuthError.swift
//  QuickMart
//
//  Created by siam on 30/06/2026.
//

import Foundation
import FirebaseAuth

enum FirebaseAuthError: LocalizedError {
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
    case weakPassword
    case userNotFound
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "The email address is invalid."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .emailAlreadyInUse:
            return "This email is already registered. Please login instead."
        case .weakPassword:
            return "Password is too weak. Please use at least 6 characters."
        case .userNotFound:
            return "No account found with this email."
        case .networkError:
            return "Network error. Please check your connection."
        case .unknown(let message):
            return message
        }
    }
    
    static func from(_ error: Error) -> FirebaseAuthError {
        let nsError = error as NSError
        guard nsError.domain == AuthErrorDomain else {
            return .unknown(error.localizedDescription)
        }
        
        switch AuthErrorCode(rawValue: nsError.code) {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .wrongPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .userNotFound:
            return .userNotFound
        case .networkError:
            return .networkError
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
