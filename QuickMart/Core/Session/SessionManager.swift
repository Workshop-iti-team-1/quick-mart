//
//  SessionManager.swift
//  QuickMart
//
//  Created by siam on 29/06/2026.
//

import Foundation
import Combine
import FirebaseAuth

enum AppState {
    case loading
    case guest
    case loggedIn
}

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var currentState: AppState = .loading
    
    private let firebaseAuth: FirebaseAuthServiceProtocol
    
    private init(firebaseAuth: FirebaseAuthServiceProtocol = FirebaseAuthService()) {
        self.firebaseAuth = firebaseAuth
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if let firebaseUser = firebaseAuth.getCurrentUser() {
            if firebaseUser.isAnonymous {
                currentState = .guest
            } else if getToken() != nil {
                currentState = .loggedIn
            } else {
                // Firebase user exists but no Shopify token — treat as guest
                currentState = .guest
            }
        } else {
            currentState = .guest
        }
    }
    
    func login(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.customerAccessToken)
        currentState = .loggedIn
    }
    
    func loginAsGuest() {
        currentState = .guest
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.customerAccessToken)
        try? firebaseAuth.signOut()
        currentState = .guest
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.customerAccessToken)
    }
}
