
//
//  LoginView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//


import SwiftUI

struct LoginView: View {
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
                    Text("Login")
                        .font(AppFonts.heading1)
                        .foregroundColor(theme.primaryText)
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(AppFonts.body)
                            .foregroundColor(theme.mutedText)
                        Button("Signup") {
                            router.popToRoot()
                            router.push(.signup)
                        }
                        .font(AppFonts.body)
                        .fontWeight(.medium)
                        .foregroundColor(theme.primary)
                    }
                }

                VStack(spacing: AppTheme.Spacing.md) {
                    CustomTextField(title: "Email", placeholder: "Enter your email", text: $email)
                    CustomTextField(title: "Password", placeholder: "Enter your password", text: $password, isSecure: true)
                }
                .padding(.top, AppTheme.Spacing.md)

                HStack {
                    Spacer()
                    Button("Forgot password?") { }
                        .font(AppFonts.body)
                        .fontWeight(.medium)
                        .foregroundColor(theme.primary)
                }

                Spacer()

                VStack(spacing: AppTheme.Spacing.sm) {
                    AppButton(title: "Login", verticalPadding: 20) { }
                    AppButton(title: "Login with Google", style: .secondary, customIcon: .googleIcon, verticalPadding: 20) { }
                }
                .padding(.top, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)

                HStack {
                    Spacer()
                    (
                        Text("By login , you agree to our ")
                            .foregroundColor(theme.mutedText)
                        + Text("Privacy Policy")
                            .foregroundColor(theme.primary)
                        + Text(" and ")
                            .foregroundColor(theme.mutedText)
                        + Text("Terms & Conditions")
                            .foregroundColor(theme.primary)
                        + Text(".")
                            .foregroundColor(theme.mutedText)
                    )
                    .font(AppFonts.caption)
                    .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(.top, AppTheme.Spacing.xl)
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.bottom, AppTheme.Spacing.xl)
        }
        .background(theme.background.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}
