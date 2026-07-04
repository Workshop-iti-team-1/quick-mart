//
//  SettingViewModel.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//

import Foundation

class ProfileViewModel : ObservableObject{
    
    @Published var user: UserEntity?
    
    init(){
        self.user = UserEntity(
            name: "Ahmed",
            email: "elsayyad123@gmail.com",
            avatarImageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqOWKFUOxzhODI6373hBEPz0YrecJYNYRlr936P0ec9g&s=10")
    }
    
    var personalItems: [MenuItem] {
        [
            MenuItem(icon: "box", title: AppStrings.Profile.shippingAddress, trailing: .chevron(route: .shippingAddresses)),
            MenuItem(icon: "card-tick", title: AppStrings.Profile.paymentMethod, trailing: .chevron(route: .paymentMethod)),
            MenuItem(icon: "receipt-edit", title: AppStrings.Profile.orderHistory, trailing: .chevron(route: .orderHistory))
        ]
    }
    
    var supportItems: [MenuItem] {
        [
            MenuItem(icon:"shield-tick", title: AppStrings.Profile.privacyPolicy, trailing: .chevron(route: .privacyPolicy)),
            MenuItem(icon:"document-text", title: AppStrings.Profile.termsConditions, trailing: .chevron(route: .termsAndConditions)),
            MenuItem(icon:"message-question", title: AppStrings.Profile.faqs, trailing: .chevron(route: .faqs))
        ]
    }
    
    var accountItems: [MenuItem] {
        [
            MenuItem(icon: "lock", title: AppStrings.Profile.changePassword, trailing: .chevron(route: .changePassword)),
            MenuItem(icon: "mobile", title: AppStrings.Profile.darkTheme, trailing: .toggle(isOn: true))
        ]
    }
    

    
    
}
