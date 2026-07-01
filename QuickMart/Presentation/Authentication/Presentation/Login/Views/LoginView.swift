
//
//  LoginView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DIContainer.shared.makeLoginViewModel()
    var router: AppRouter
    var body: some View {
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image.appLogo
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(AppStrings.Auth.login)
                            .appTextStyle(.heading1, color: .primary)
                        HStack(spacing: 4) {
                            Text(AppStrings.Auth.dontHaveAccount)
                                .appTextStyle(.body, color: .gray)
                            Button(AppStrings.Auth.signup) {
                                router.popToRoot()
                                router.push(.signup)
                            }
                            .appTextStyle(.body, color: .cyanPrimary)
                        }
                    }

                    VStack(spacing: 16) {
                        CustomTextField(title: AppStrings.Auth.email, placeholder: AppStrings.Auth.enterEmail, text: $viewModel.email)
                        CustomTextField(title: AppStrings.Auth.password, placeholder: AppStrings.Auth.enterPassword, text: $viewModel.password, isSecure: true)
                    }
                    .padding(.top, 16)

                    HStack {
                        Spacer()
                        Button(AppStrings.Auth.forgotPassword) { }
                            .appTextStyle(.body, color: .cyanPrimary)
                    }

                    Spacer()

                    VStack(spacing: 8) {
                        AppButton(title: AppStrings.Auth.login, verticalPadding: 20) { 
                            viewModel.login()
                        }
                        .disabled(viewModel.isLoading)
                        
                        AppButton(title: AppStrings.Auth.loginWithGoogle, style: .secondary, customIcon: .googleIcon, verticalPadding: 20) { }
                        
                        Button(AppStrings.Auth.loginAsGuest) { 
                            // TODO: Handle guest login
                        }
                        .appTextStyle(.body, color: .cyanPrimary)
                        .padding(.top, 8)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)

                    HStack {
                        Spacer()
                        (
                            Text(AppStrings.Auth.termsPrefix)
                                .foregroundColor(.gray)
                            + Text(AppStrings.Auth.privacyPolicy)
                                .foregroundColor(.cyanPrimary)
                            + Text(AppStrings.Auth.and)
                                .foregroundColor(.gray)
                            + Text(AppStrings.Auth.termsConditions)
                                .foregroundColor(.cyanPrimary)
                            + Text(".")
                                .foregroundColor(.gray)
                        )
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.top, 32)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if viewModel.isLoading {
                CustomLoadingView()
            }
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showError) {
            Button(AppStrings.General.ok, role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isAuthenticated) { authenticated in
            if authenticated {
                // Navigate to home or next screen
                print("Authenticated, navigating...")
            }
        }
    }
}
