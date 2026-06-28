//
//  SignupView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//


import SwiftUI

struct SignupView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
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
                        CustomTextField(title: AppStrings.Auth.fullName, placeholder: AppStrings.Auth.enterName, text: $fullName)
                        CustomTextField(title: AppStrings.Auth.email, placeholder: AppStrings.Auth.enterEmail, text: $email)
                        CustomTextField(title: AppStrings.Auth.password, placeholder: AppStrings.Auth.enterPassword, text: $password, isSecure: true)
                    }
                    .padding(.top, 16)

                    Spacer()

                    VStack(spacing: 8) {
                        AppButton(title: AppStrings.Auth.createAccount, verticalPadding: 20) { }
                        AppButton(title: AppStrings.Auth.signupWithGoogle, style: .secondary, customIcon: .googleIcon, verticalPadding: 20) { }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

