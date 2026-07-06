//
//  SettingViewModel.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//
//

// SettingViewModel.swift
import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {

    @Published var user: UserEntity?
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @AppStorage("selectedCurrency") var selectedCurrency: String = AppConstants.defultAppCurrency

    private let getCustomerUseCase: GetCustomerUseCaseProtocol

    init(getCustomerUseCase: GetCustomerUseCaseProtocol) {
        self.getCustomerUseCase = getCustomerUseCase
    }

    func loadProfile() {
        Task {
            isLoading = true
            do {
                user = try await getCustomerUseCase.execute()
            } catch {
                // fallback to Firebase email
                let email = SessionManager.shared.currentUserId
                user = UserEntity(name: nil, email: email, avatarImageURL: nil)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    var personalItems: [MenuItem] {[
        MenuItem(icon: "box", title: AppStrings.Profile.shippingAddress,
                 trailing: .chevron(route: .shippingAddresses)),
        MenuItem(icon: "card-tick", title: AppStrings.Profile.paymentMethod,
                 trailing: .chevron(route: .paymentMethod)),
        MenuItem(icon: "receipt-edit", title: AppStrings.Profile.orderHistory,
                 trailing: .chevron(route: .orderHistory))
    ]}

    var supportItems: [MenuItem] {[
        MenuItem(icon: "shield-tick", title: AppStrings.Profile.privacyPolicy,
                 trailing: .chevron(route: .privacyPolicy)),
        MenuItem(icon: "document-text", title: AppStrings.Profile.termsConditions,
                 trailing: .chevron(route: .termsAndConditions)),
        MenuItem(icon: "message-question", title: AppStrings.Profile.faqs,
                 trailing: .chevron(route: .faqs))
    ]}

    var accountItems: [MenuItem] {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        return [
    
            MenuItem(icon: "mobile", title: AppStrings.Profile.darkTheme,
                     trailing: .toggle(isOn: isDarkMode)),
            MenuItem(icon: "dollarsign.circle", title: AppStrings.Profile.currency,
                     trailing: .chevron(route: .currencyPicker, value: selectedCurrency))
        ]
    }
}
