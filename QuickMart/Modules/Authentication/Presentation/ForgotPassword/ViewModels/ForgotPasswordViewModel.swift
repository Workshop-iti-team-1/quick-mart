//
//  ForgotPasswordViewModel.swift
//  QuickMart
//
//  Created by siam on 30/06/2026.
//

import Foundation

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showSuccess: Bool = false
    
    private let recoverPasswordUseCase: RecoverPasswordUseCaseProtocol
    
    init(recoverPasswordUseCase: RecoverPasswordUseCaseProtocol) {
        self.recoverPasswordUseCase = recoverPasswordUseCase
    }
    
    func sendResetLink() {
        isLoading = true
        showError = false
        errorMessage = nil
        
        Task {
            do {
                try await recoverPasswordUseCase.execute(email: email)
                self.isLoading = false
                self.showSuccess = true
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
