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
    @StateObject private var viewModel = DIContainer.shared
        .makeProfileViewModel()
    @State private var showLogoutAlert = false
    @Environment(\.colorScheme) var colorScheme

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
        .alert(AppStrings.Profile.logout, isPresented: $showLogoutAlert) {
            Button(AppStrings.General.cancel, role: .cancel) {}
            Button(AppStrings.Profile.logout, role: .destructive) {
                SessionManager.shared.logout()
            }
        } message: {
            Text(AppStrings.Profile.logoutConfirm)
        }
    }

    // MARK: - Guest
    private var guestView: some View {
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
                    Text(AppStrings.Profile.welcomeGuest)
                        .appTextStyle(.heading2, color: .appWhite)
                    Text(AppStrings.Profile.signInPrompt)
                        .appTextStyle(.caption, color: .appWhite.opacity(0.8))
                }
            }
            .padding(.top, 60)
            .padding(.bottom, 32)

            VStack(spacing: 0) {

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        MenuSection(
                            title: AppStrings.Profile.supportInfo,
                            items: viewModel.supportItems,
                            router: router
                        )
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                }

                VStack(spacing: 12) {
                    AppButton(title: AppStrings.Profile.login) {
                        router.push(.login)
                    }

                    Button {
                        router.push(.signup)
                    } label: {
                        Text(AppStrings.Profile.createAccount)
                            .appTextStyle(.button, color: .cyanPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.cyanPrimary, lineWidth: 1.5)
                            )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.backGround)
            .clipShape(
                RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
        }
    }
    // MARK: - Logged In
    private var loggedInView: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isLoading {
                ProfileHeaderCardSkeleton()
                    .redacted(reason: .placeholder)
                    .shimmer()
            } else if let user = viewModel.user {
                ProfileHeaderCard(
                    user: user,
                    onInfoTap: { router.push(.userInfo(user: user)) }
                )
            }

            VStack(alignment: .leading, spacing: 0) {
                MenuSection(
                    title: AppStrings.Profile.personalInfo,
                    items: viewModel.personalItems, router: router)
                MenuSection(
                    title: AppStrings.Profile.supportInfo,
                    items: viewModel.supportItems, router: router)
                MenuSection(
                    title: AppStrings.Profile.accountManagement,
                    items: viewModel.accountItems, router: router
                ) { item, isOn in
                    if item.title == AppStrings.Profile.darkTheme {
                        UserDefaults.standard.set(isOn, forKey: "isDarkMode")
                    }
                }
                MenuSection(
                    title: AppStrings.Profile.aiFeatures,
                    items: [
                        MenuItem(
                            icon: "sparkles",
                            title: AppStrings.Profile.shoppingInsights,
                            trailing: .chevron(route: .aiInsights)),
                        MenuItem(
                            icon: "camera.viewfinder",
                            title: AppStrings.Profile.searchByPhoto,
                            trailing: .chevron(route: .aiImageSearch)),
                    ],
                    router: router
                )

                logoutButton
            }
            .padding(.top, 24)
            .background(Color.backGround)
            .clipShape(
                RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
            )
        }
    }

    // MARK: - Logout
    private var logoutButton: some View {
        Button {
            showLogoutAlert = true
        } label: {
            HStack(spacing: 12) {
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                Text(AppStrings.Profile.logout)
                    .appTextStyle(.button, color: .appRed)
                Spacer()
            }
            .foregroundColor(.appRed)
            .padding(.vertical, 16)
            .background(Color.appRed.opacity(0.08))
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 32)
    }
}
