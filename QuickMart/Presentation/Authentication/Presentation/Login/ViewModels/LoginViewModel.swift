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
    
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
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
                print("Login successful! Token: \(token.accessToken)")
                self.isAuthenticated = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
