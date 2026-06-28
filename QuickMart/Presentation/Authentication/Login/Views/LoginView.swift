
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
                        Text("Login")
                            .appTextStyle(.heading1, color: .primary)
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .appTextStyle(.body, color: .gray)
                            Button("Signup") {
                                router.popToRoot()
                                router.push(.signup)
                            }
                            .appTextStyle(.body, color: .cyanPrimary)
                        }
                    }

                    VStack(spacing: 16) {
                        CustomTextField(title: "Email", placeholder: "Enter your email", text: $email)
                        CustomTextField(title: "Password", placeholder: "Enter your password", text: $password, isSecure: true)
                    }
                    .padding(.top, 16)

                    HStack {
                        Spacer()
                        Button("Forgot password?") { }
                            .appTextStyle(.body, color: .cyanPrimary)
                    }

                    Spacer()

                    VStack(spacing: 8) {
                        AppButton(title: "Login", verticalPadding: 20) { }
                        AppButton(title: "Login with Google", style: .secondary, customIcon: .googleIcon, verticalPadding: 20) { }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 32)

                    HStack {
                        Spacer()
                        (
                            Text("By login , you agree to our ")
                                .foregroundColor(.gray)
                            + Text("Privacy Policy")
                                .foregroundColor(.cyanPrimary)
                            + Text(" and ")
                                .foregroundColor(.gray)
                            + Text("Terms & Conditions")
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
    }
}
