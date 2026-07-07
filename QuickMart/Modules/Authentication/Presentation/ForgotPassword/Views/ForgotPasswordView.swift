//
//  ForgotPasswordView.swift
//  QuickMart
//
//  Created by siam on 30/06/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = DIContainer.shared
        .makeForgotPasswordViewModel()
    var router: AppRouter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        router.pop()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Image.appLogo
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            .padding(.top, 8)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(AppStrings.Auth.forgotPasswordTitle)
                                .appTextStyle(.heading1, color: .primary)
                            Text(AppStrings.Auth.forgotPasswordSubtitle)
                                .appTextStyle(.body, color: .gray)
                                .padding(.top, 4)
                        }

                        VStack(spacing: 16) {
                            CustomTextField(
                                title: AppStrings.Auth.email,
                                placeholder: AppStrings.Auth.enterEmail,
                                text: $viewModel.email)
                        }
                        .padding(.top, 16)

                        VStack(spacing: 16) {
                            AppButton(
                                title: AppStrings.Auth.sendResetLink,
                                verticalPadding: 20
                            ) {
                                viewModel.sendResetLink()
                            }
                            .disabled(viewModel.isLoading)
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if viewModel.isLoading {
                ShimmeringLoadingOverlay(message: "Sending Link...")
            }
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showError) {
            Button(AppStrings.General.ok, role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert(
            AppStrings.Auth.forgotPasswordTitle,
            isPresented: $viewModel.showSuccess
        ) {
            Button(AppStrings.General.ok, role: .cancel) {
                router.pop()
            }
        } message: {
            Text(AppStrings.Auth.resetLinkSent)
        }
    }
}
