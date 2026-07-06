//
//  ProfileView.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//
// ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @Environment(AppRouter.self) private var router
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = DIContainer.shared.makeProfileViewModel()
    @State private var showLogoutAlert = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.backGround.ignoresSafeArea()

            VStack {
                Color.cyanPrimary.frame(height: 300)
                Spacer()
            }
            .ignoresSafeArea()

            if sessionManager.currentState == .guest {
                guestView
            } else {
                loggedInView
            }
        }
        .onAppear {
            if sessionManager.currentState != .guest {
                viewModel.loadProfile()
            }
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                SessionManager.shared.logout()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    // MARK: - Guest
    private var guestView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.appWhite.opacity(0.2))
                            .frame(width: 90, height: 90)
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.appWhite)
                    }

                    VStack(spacing: 4) {
                        Text("Welcome, Guest")
                            .appTextStyle(.heading2, color: .appWhite)
                        Text("Sign in to access your full profile")
                            .appTextStyle(.caption, color: .appWhite.opacity(0.8))
                    }

                    VStack(spacing: 10) {
                        AppButton(title: "Login") {
                            router.push(.login)
                        }

                        Button {
                            router.push(.signup)
                        } label: {
                            Text("Create Account")
                                .appTextStyle(.button, color: .cyanPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.appWhite)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.appWhite, lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                }
                .padding(.top, 60)
                .padding(.bottom, 32)

                VStack(alignment: .leading, spacing: 12) {
                    MenuSection(
                        title: AppStrings.Profile.supportInfo,
                        items: viewModel.supportItems,
                        router: router
                    )
                }
                .padding(.top, 24)
                .padding(.bottom, 32)
                .background(Color.backGround)
                .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
            }
        }
    }

    // MARK: - Logged In
    private var loggedInView: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isLoading {
                ProgressView().padding(.top, 80)
            }

            if let user = viewModel.user {
                ProfileHeaderCard(user: user) {
                    showLogoutAlert = true
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                MenuSection(title: AppStrings.Profile.personalInfo,
                            items: viewModel.personalItems, router: router)
                MenuSection(title: AppStrings.Profile.supportInfo,
                            items: viewModel.supportItems, router: router)
                MenuSection(title: AppStrings.Profile.accountManagement,
                            items: viewModel.accountItems, router: router) { item, isOn in
                    if item.title == AppStrings.Profile.darkTheme {
                        UserDefaults.standard.set(isOn, forKey: "isDarkMode")
                    }
                }
                Spacer()
            }
            .padding(.top, 24)
            .background(Color.backGround)
            .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
            .frame(minHeight: UIScreen.main.bounds.height)
        }
    }
}
