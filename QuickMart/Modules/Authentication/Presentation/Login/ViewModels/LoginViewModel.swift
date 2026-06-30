//
//  LoginViewModel.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }
    @Published var showError = false
    @Published var isAuthenticated = false
    @Published var isGuestAuthenticated = false
    
    private let loginUseCase: LoginUseCaseProtocol
    private let guestLoginUseCase: GuestLoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol, guestLoginUseCase: GuestLoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
        self.guestLoginUseCase = guestLoginUseCase
    }
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = AppStrings.Auth.Validation.emptyEmailPassword
            return
        }
        
        guard email.isValidEmail else {
            errorMessage = AppStrings.Auth.Validation.invalidEmail
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let token = try await loginUseCase.execute(email: email, password: password)
                SessionManager.shared.login(token: token.accessToken)
                self.isAuthenticated = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func loginAsGuest() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await guestLoginUseCase.execute()
                SessionManager.shared.loginAsGuest()
                self.isGuestAuthenticated = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
