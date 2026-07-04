//
//  ProfileView.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
//

import SwiftUI

struct ProfileView: View {
    var router: AppRouter
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack(alignment:.topLeading){
            Color.cyanPrimary.ignoresSafeArea()
            ScrollView{
                if let user = viewModel.user {
                    ProfileHeaderCard(
                        user: user
                    ){
                        // handle logout here
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    MenuSection(title: AppStrings.Profile.personalInfo, items: viewModel.personalItems, router: router)
                    
                    MenuSection(title: AppStrings.Profile.supportInfo, items: viewModel.supportItems, router: router)
                    
                    MenuSection(title: AppStrings.Profile.accountManagement, items: viewModel.accountItems, router: router) { item, isOn in
                        print("\(item.title) is now \(isOn)")
                    }
                    Spacer()
                }
                .padding(.top, 24)
                .background(Color.appWhite)
                .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        
            
        }
    }
}

/*
 
 ScrollView {
     VStack(spacing: 0) {
         ProfileHeaderCard(
             name: "Ahmed Raza",
             email: "ahmedraza@gmail.com",
             avatarImageURL: nil
         )
         .padding(.top, 20)
         .padding(.bottom, 30)
         VStack(alignment: .leading, spacing: 0) {
             MenuSection(title: AppStrings.Profile.personalInfo, items: viewModel.personalItems, router: router)
             MenuSection(title: AppStrings.Profile.supportInfo, items: viewModel.supportItems, router: router)
             MenuSection(title: AppStrings.Profile.accountManagement, items: viewModel.accountItems, router: router) { item, isOn in
                 print("\(item.title) is now \(isOn)")
             }
             
          
             Spacer(minLength: 50)
         }
         .padding(.horizontal, 20)
         .padding(.top, 24)
         .background(Color.appWhite)
         .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
     }}
 */


// MARK: - Preview
struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(router: AppRouter())
    }
}
