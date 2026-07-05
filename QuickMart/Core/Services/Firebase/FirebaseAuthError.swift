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
            return AppStrings.FirebaseError.invalidEmail
        case .wrongPassword:
            return AppStrings.FirebaseError.wrongPassword
        case .emailAlreadyInUse:
            return AppStrings.FirebaseError.emailAlreadyInUse
        case .weakPassword:
            return AppStrings.FirebaseError.weakPassword
        case .userNotFound:
            return AppStrings.FirebaseError.userNotFound
        case .networkError:
            return AppStrings.FirebaseError.networkError
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
