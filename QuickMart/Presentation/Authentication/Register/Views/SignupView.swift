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
                        Text("Signup")
                            .appTextStyle(.heading1, color: .primary)
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .appTextStyle(.body, color: .gray)
                            Button("Login") {
                                router.popToRoot()
                                router.push(.login)
                            }
                            .appTextStyle(.body, color: .cyanPrimary)
                        }
                    }

                    VStack(spacing: 16) {
                        CustomTextField(title: "Full Name", placeholder: "Enter your name", text: $fullName)
                        CustomTextField(title: "Email", placeholder: "Enter your email", text: $email)
                        CustomTextField(title: "Password", placeholder: "Enter your password", text: $password, isSecure: true)
                    }
                    .padding(.top, 16)

                    Spacer()

                    VStack(spacing: 8) {
                        AppButton(title: "Create Account", verticalPadding: 20) { }
                        AppButton(title: "Signup with Google", style: .secondary, customIcon: .googleIcon, verticalPadding: 20) { }
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

