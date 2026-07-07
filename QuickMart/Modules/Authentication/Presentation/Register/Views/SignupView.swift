//
//  SignupView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = DIContainer.shared
        .makeRegisterViewModel()
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
                        Text(AppStrings.Auth.signup)
                            .appTextStyle(.heading1, color: .primary)
                        HStack(spacing: 4) {
                            Text(AppStrings.Auth.alreadyHaveAccount)
                                .appTextStyle(.body, color: .gray)
                            Button(AppStrings.Auth.login) {
                                router.popToRoot()
                                router.push(.login)
                            }
                            .appTextStyle(.body, color: .cyanPrimary)
                        }
                    }

                    VStack(spacing: 16) {
                        CustomTextField(
                            title: AppStrings.Auth.firstName,
                            placeholder: AppStrings.Auth.enterFirstName,
                            text: $viewModel.firstName)
                        CustomTextField(
                            title: AppStrings.Auth.lastName,
                            placeholder: AppStrings.Auth.enterLastName,
                            text: $viewModel.lastName)
                        CustomTextField(
                            title: AppStrings.Auth.email,
                            placeholder: AppStrings.Auth.enterEmail,
                            text: $viewModel.email)
                        CustomTextField(
                            title: AppStrings.Auth.password,
                            placeholder: AppStrings.Auth.enterPassword,
                            text: $viewModel.password, isSecure: true)
                        CustomTextField(
                            title: AppStrings.Auth.confirmPassword,
                            placeholder: AppStrings.Auth.enterConfirmPassword,
                            text: $viewModel.confirmPassword, isSecure: true)
                    }
                    .padding(.top, 16)

                    Spacer()

                    VStack(spacing: 8) {
                        AppButton(
                            title: AppStrings.Auth.createAccount,
                            verticalPadding: 20
                        ) {
                            viewModel.register()
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if viewModel.isLoading {
                ShimmeringLoadingOverlay(message: "Creating Account...")
            }
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showError) {
            Button(AppStrings.General.ok, role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isRegistered) { registered in
            if registered {
                router.popToRoot()
            }
        }
    }
}
