//
//  CustomToolbar.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//



import SwiftUI

struct CustomToolbar: ToolbarContent {
    var onSearch: () -> Void = {}

    var body: some ToolbarContent {
       
        ToolbarItem(placement: .navigationBarLeading) {
         
            Image.appLogo
                  .resizable()
                  .scaledToFit()
                  .frame(height: 32)
                  .padding(.vertical, 12)

        }


        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 12) {
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.appBlack)
                }

             
            }
        }
    }
}

extension View {
    func customToolbar(onSearch: @escaping () -> Void = {}) -> some View {
        self.toolbar {
            CustomToolbar(onSearch: onSearch)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
