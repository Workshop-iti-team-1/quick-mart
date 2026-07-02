//
//  ProfileView.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//

import SwiftUI

struct ProfileView: View {
    
    var router: AppRouter
    
    private var personalItems: [MenuItem] {
        [
            MenuItem(icon: "box", title: AppStrings.Profile.shippingAddress, trailing: .chevron(route: .shippingAddress)),
            MenuItem(icon: "card-tick", title: AppStrings.Profile.paymentMethod, trailing: .chevron(route: .paymentMethod)),
            MenuItem(icon: "document-text", title: AppStrings.Profile.orderHistory, trailing: .chevron(route: .orderHistory))
        ]
    }
    
    private var supportItems: [MenuItem] {
        [
            MenuItem(icon:"shield-tick", title: AppStrings.Profile.privacyPolicy, trailing: .chevron(route: .privacyPolicy)),
            MenuItem(icon:"receipt-edit", title: AppStrings.Profile.termsConditions, trailing: .chevron(route: .termsAndConditions)),
            MenuItem(icon:"message-question", title: AppStrings.Profile.faqs, trailing: .chevron(route: .faqs))
        ]
    }
    
    private var accountItems: [MenuItem] {
        [
            MenuItem(icon: "lock", title: AppStrings.Profile.changePassword, trailing: .chevron(route: .changePassword)),
            MenuItem(icon: "mobile", title: AppStrings.Profile.darkTheme, trailing: .toggle(isOn: true))
        ]
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                // Background color for the whole screen
                Color.backGround.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Profile Card
                    ProfileHeaderCard(
                        name: "Ahmed El-Sayyad Mohamed",
                        email: "ahmedelsayyad123@gmail.com",
                        avatarImageURL: nil
                    )
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    // Main Content Section
                    VStack(alignment: .leading, spacing: 0) {
                        MenuSection(title: AppStrings.Profile.personalInfo, items: personalItems, router: router)
                        MenuSection(title: AppStrings.Profile.supportInfo, items: supportItems, router: router)
                        MenuSection(title: AppStrings.Profile.accountManagement, items: accountItems, router: router) { item, isOn in
                            print("\(item.title) is now \(isOn)")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                    .background(Color.appWhite) // Set your desired background color here
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                }
            }
        }
        .background(Color.backGround)
    }
}

// MARK: - Helper for Rounded Corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(router: AppRouter())
    }
}
