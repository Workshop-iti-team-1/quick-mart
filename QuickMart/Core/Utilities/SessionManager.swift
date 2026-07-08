//
//  SessionManager.swift
//  QuickMart
//
//  Created by siam on 29/06/2026.
//

import Combine
import FirebaseAuth
import Foundation

enum AppState {
    case loading
    case unauthenticated
    case guest
    case loggedIn
}

class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var currentState: AppState = .loading

    private let firebaseAuth: FirebaseAuthServiceProtocol

    private init(
        firebaseAuth: FirebaseAuthServiceProtocol = FirebaseAuthService()
    ) {
        self.firebaseAuth = firebaseAuth
    }

    func configure() {
        checkUserStatus()
    }

    func checkUserStatus() {
        if let firebaseUser = firebaseAuth.getCurrentUser() {
            if firebaseUser.isAnonymous {
                currentState = .guest
            } else if getToken() != nil {
                currentState = .loggedIn
            } else {
                currentState = .guest
            }
        } else {
            currentState = .unauthenticated
        }
    }
    // Add this helper method inside SessionManager
    private func clearCartState() {
        // Destroy the stale cart ID tied to the previous session
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cartId)
        // Broadcast the clear event to reset the badge globally
        CartEventsBus.shared.cartCleared.send()
    }

    func login(token: String) {
        clearCartState()
        UserDefaults.standard.set(
            token, forKey: UserDefaultsKeys.customerAccessToken)
        currentState = .loggedIn
    }

    func loginAsGuest() {
        clearCartState()
        currentState = .guest
    }

    func logout() {
        clearCartState()
        UserDefaults.standard.removeObject(
            forKey: UserDefaultsKeys.customerAccessToken)
        try? firebaseAuth.signOut()
        currentState = .unauthenticated
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(
            forKey: UserDefaultsKeys.customerAccessToken)
    }

    /// Scoping key for anything user-specific stored locally (e.g. favorites).
    /// Every Firebase user — including anonymous/guest sessions — has a stable UID,
    /// so this correctly separates guest favorites from each logged-in account's favorites.
    var currentUserId: String {
        firebaseAuth.getCurrentUser()?.uid ?? "unauthenticated"
    }
}
