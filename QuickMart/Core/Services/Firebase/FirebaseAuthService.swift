//
//  FirebaseAuthService.swift
//  QuickMart
//
//  Created by siam on 30/06/2026.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthServiceProtocol {
    func signUp(email: String, password: String) async throws -> FirebaseUser
    func signIn(email: String, password: String) async throws -> FirebaseUser
    func signInAnonymously() async throws -> FirebaseUser
    func signOut() throws
    func getCurrentUser() -> FirebaseUser?
    var isLoggedIn: Bool { get }
    var isGuest: Bool { get }
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    
    private var auth: Auth {
        Auth.auth()
    }
    
    // MARK: - Sign Up
    
    func signUp(email: String, password: String) async throws -> FirebaseUser {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            return mapUser(result.user)
        } catch {
            throw FirebaseAuthError.from(error)
        }
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String) async throws -> FirebaseUser {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            return mapUser(result.user)
        } catch {
            throw FirebaseAuthError.from(error)
        }
    }
    
    // MARK: - Anonymous Sign In
    
    func signInAnonymously() async throws -> FirebaseUser {
        do {
            let result = try await auth.signInAnonymously()
            return mapUser(result.user)
        } catch {
            throw FirebaseAuthError.from(error)
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            throw FirebaseAuthError.from(error)
        }
    }
    
    // MARK: - Current User
    
    func getCurrentUser() -> FirebaseUser? {
        guard let user = auth.currentUser else { return nil }
        return mapUser(user)
    }
    
    var isLoggedIn: Bool {
        auth.currentUser != nil
    }
    
    var isGuest: Bool {
        auth.currentUser?.isAnonymous ?? false
    }
    
    // MARK: - Private
    
    private func mapUser(_ user: User) -> FirebaseUser {
        FirebaseUser(
            uid: user.uid,
            email: user.email,
            isAnonymous: user.isAnonymous
        )
    }
}
