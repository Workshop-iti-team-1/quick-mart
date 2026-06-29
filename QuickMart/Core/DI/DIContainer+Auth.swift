//
//  DIContainer+Auth.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import Foundation

extension DIContainer {
    
    var rawGraphQLClient: ShopifyGraphQLClientProtocol {
        return RawGraphQLClient()
    }
    
    var authRemoteDataSource: AuthRemoteDataSourceProtocol {
        return AuthRemoteDataSource(client: rawGraphQLClient)
    }
    
    var authRepository: AuthRepositoryProtocol {
        return AuthRepositoryImpl(remoteDataSource: authRemoteDataSource)
    }
    
    var loginUseCase: LoginUseCaseProtocol {
        return LoginUseCase(repository: authRepository)
    }
    
    var registerUseCase: RegisterUseCaseProtocol {
        return RegisterUseCase(repository: authRepository)
    }
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: loginUseCase)
    }
    
    @MainActor
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(registerUseCase: registerUseCase)
    }
}
