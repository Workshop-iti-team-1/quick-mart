//
//  UserInfoViewModel.swift
//  QuickMart
//
//  Created by siam on 07/07/2026.
//

import Foundation
import UIKit

@MainActor
class UserInfoViewModel: ObservableObject {
    @Published var user: UserEntity
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    
    private let uploadProfileImageUseCase: UploadProfileImageUseCaseProtocol
    
    init(user: UserEntity, uploadProfileImageUseCase: UploadProfileImageUseCaseProtocol) {
        self.user = user
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
    }
    
    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            self.errorMessage = AppStrings.UserInfo.failedToProcessImage
            self.showError = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let url = try await uploadProfileImageUseCase.execute(imageData: imageData)
                
                // Cache the url in UserDefaults using the user's email
                if let email = user.email {
                    UserDefaults.standard.set(url, forKey: "avatar_\(email)")
                }
                
                // Update local state to trigger UI refresh
                self.user = UserEntity(
                    name: self.user.name,
                    email: self.user.email,
                    avatarImageURL: url
                )
                
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
                self.isLoading = false
            }
        }
    }
}
