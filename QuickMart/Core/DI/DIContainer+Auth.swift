//
//  DIContainer+Auth.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

extension DIContainer {
    
    // MARK: - Firebase
    
    var firebaseAuthService: FirebaseAuthServiceProtocol {
        return FirebaseAuthService()
    }
    
    // MARK: - Data Sources
    
    var authRemoteDataSource: AuthRemoteDataSourceProtocol {
        return AuthRemoteDataSource(client: graphQLClient)
    }
    
    // MARK: - Repository
    
    var authRepository: AuthRepositoryProtocol {
        return AuthRepositoryImpl(
            remoteDataSource: authRemoteDataSource,
            firebaseAuth: firebaseAuthService
        )
    }
    
    // MARK: - Use Cases
    
    var loginUseCase: LoginUseCaseProtocol {
        return LoginUseCase(repository: authRepository)
    }
    
    var registerUseCase: RegisterUseCaseProtocol {
        return RegisterUseCase(repository: authRepository)
    }
    
    var guestLoginUseCase: GuestLoginUseCaseProtocol {
        return GuestLoginUseCase(repository: authRepository)
    }
    
    // MARK: - View Models
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: loginUseCase,
            guestLoginUseCase: guestLoginUseCase
        )
    }
    
    @MainActor
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(registerUseCase: registerUseCase)
    }
}
