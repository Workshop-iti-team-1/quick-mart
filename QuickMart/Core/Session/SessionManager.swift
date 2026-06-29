//
//  SessionManager.swift
//  QuickMart
//
//  Created by siam on 29/06/2026.
//

import Foundation
import Combine

enum AppState {
    case loading
    case guest
    case loggedIn
}

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var currentState: AppState = .loading
    
    private init() {
        checkUserStatus()
    }
    
    func checkUserStatus() {
        if let _ = getToken() {
            currentState = .loggedIn
        } else {
            currentState = .guest
        }
    }
    
    func login(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.customerAccessToken)
        currentState = .loggedIn
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.customerAccessToken)
        currentState = .guest
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.customerAccessToken)
    }
}
