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
    @Environment(\.appTheme) var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                Image.appLogo
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .padding(.top, AppTheme.Spacing.md)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Signup")
                        .font(AppFonts.heading1)
                        .foregroundColor(theme.primaryText)
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(AppFonts.body)
                            .foregroundColor(theme.mutedText)
                        Button("Login") {
                            router.popToRoot()
                            router.push(.login)
                        }
                        .font(AppFonts.body)
                        .fontWeight(.medium)
                        .foregroundColor(theme.primary)
                    }
                }

                VStack(spacing: AppTheme.Spacing.md) {
                    CustomTextField(title: "Full Name", placeholder: "Enter your name", text: $fullName)
                    CustomTextField(title: "Email", placeholder: "Enter your email", text: $email)
                    CustomTextField(title: "Password", placeholder: "Enter your password", text: $password, isSecure: true)
                }
                .padding(.top, AppTheme.Spacing.md)

                Spacer()

                VStack(spacing: AppTheme.Spacing.sm) {
                    AppButton(title: "Create Account", verticalPadding: 20) { }
                    AppButton(title: "Signup with Google", style: .secondary, customIcon: .googleIcon, verticalPadding: 20) { }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.bottom, AppTheme.Spacing.xl)
        }
        .background(theme.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

