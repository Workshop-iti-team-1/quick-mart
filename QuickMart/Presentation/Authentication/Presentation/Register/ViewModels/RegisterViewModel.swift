//
//  RegisterViewModel.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var acceptsMarketing = false
    
    @Published var isLoading = false
    @Published var errorMessage: String? {
        didSet {
            showError = errorMessage != nil
        }
    }
    @Published var showError = false
    @Published var isRegistered = false
    
    private let registerUseCase: RegisterUseCaseProtocol
    
    init(registerUseCase: RegisterUseCaseProtocol) {
        self.registerUseCase = registerUseCase
    }
    
    func register() {
        guard !firstName.isEmpty, !lastName.isEmpty else {
            errorMessage = AppStrings.Auth.Validation.emptyName
            return
        }
        
        guard email.isValidEmail else {
            errorMessage = AppStrings.Auth.Validation.invalidEmail
            return
        }
        
        guard password.isValidPassword else {
            errorMessage = AppStrings.Auth.Validation.shortPassword
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = AppStrings.Auth.Validation.passwordsNotMatch
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let customer = try await registerUseCase.execute(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password,
                    acceptsMarketing: acceptsMarketing
                )
                print("Registered! Customer ID: \(customer.id)")
                self.isRegistered = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}