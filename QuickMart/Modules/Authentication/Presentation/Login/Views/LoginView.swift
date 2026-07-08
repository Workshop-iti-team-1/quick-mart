//
//  LoginView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DIContainer.shared.makeLoginViewModel()
    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()

            ScrollView {
                mainContent
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay {
            if viewModel.isLoading {
                ShimmeringLoadingOverlay(message: "Authenticating...")
            }
        }
        .alert(AppStrings.General.error, isPresented: $viewModel.showError) {
            Button(AppStrings.General.ok, role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isAuthenticated) { _, authenticated in
            if authenticated { router.popToRoot() }
        }
        .onChange(of: viewModel.isGuestAuthenticated) { _, isGuest in
            if isGuest { router.popToRoot() }
        }
    }

    // MARK: - Components

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            logoSection
            headerSection
            inputFieldsSection
            forgotPasswordSection
            Spacer()
            actionsSection
            termsSection
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }

    private var logoSection: some View {
        Image.appLogo
            .resizable()
            .scaledToFit()
            .frame(height: 32)
            .padding(.top, 16)
    }

    private var headerSection: some View {
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
    }

    private var inputFieldsSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                title: AppStrings.Auth.email,
                placeholder: AppStrings.Auth.enterEmail, text: $viewModel.email)
            CustomTextField(
                title: AppStrings.Auth.password,
                placeholder: AppStrings.Auth.enterPassword,
                text: $viewModel.password, isSecure: true)
        }
        .padding(.top, 16)
    }

    private var forgotPasswordSection: some View {
        HStack {
            Spacer()
            Button(AppStrings.Auth.forgotPassword) {
                router.push(.forgotPassword)
            }
            .appTextStyle(.body, color: .cyanPrimary)
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 8) {
            AppButton(title: AppStrings.Auth.login, verticalPadding: 20) {
                viewModel.login()
            }
            .disabled(viewModel.isLoading)

            Button {
                viewModel.loginAsGuest()
            } label: {
                Text(AppStrings.Auth.loginAsGuest)
                    .appTextStyle(.button, color: .cyanPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.appWhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.cyanPrimary, lineWidth: 1.5)
                    )
            }
            .appTextStyle(.body, color: .cyanPrimary)
            .padding(.top, 8)

        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }

    private var termsSection: some View {
        Text(termsAttributedString)
            .font(.system(size: 12, weight: .regular))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .multilineTextAlignment(.center)
            .padding(.top, 32)
            .padding(.horizontal, 16)
            .environment(
                \.openURL,
                OpenURLAction { url in
                    switch url.absoluteString {
                    case "app://privacy":
                        router.push(.privacyPolicy)
                    case "app://terms":
                        router.push(.termsAndConditions)
                    default:
                        break
                    }
                    return .handled
                })
    }

    private var termsAttributedString: AttributedString {
        var prefix = AttributedString("\(AppStrings.Auth.termsPrefix) ")
        prefix.foregroundColor = .gray

        var privacy = AttributedString(AppStrings.Auth.privacyPolicy)
        privacy.foregroundColor = .cyanPrimary
        privacy.underlineStyle = .single
        privacy.link = URL(string: "app://privacy")

        var and = AttributedString(" \(AppStrings.Auth.and) ")
        and.foregroundColor = .gray

        let termsText = AppStrings.Auth.termsConditions
            .replacingOccurrences(of: " ", with: "\u{00A0}")
        var terms = AttributedString(termsText)
        terms.foregroundColor = .cyanPrimary
        terms.underlineStyle = .single
        terms.link = URL(string: "app://terms")

        var period = AttributedString(".")
        period.foregroundColor = .gray

        return prefix + privacy + and + terms + period
    }
}
