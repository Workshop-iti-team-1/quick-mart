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
    @Published var errorMessage: String?
    @Published var isRegistered = false
    
    private let registerUseCase: RegisterUseCaseProtocol
    
    init(registerUseCase: RegisterUseCaseProtocol) {
        self.registerUseCase = registerUseCase
    }
    
    func register() {
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "Please fill all fields and ensure passwords match."
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