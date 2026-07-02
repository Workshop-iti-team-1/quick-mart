//
//  CustomToolbar.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


import SwiftUI

struct CustomToolbar: ToolbarContent {
    var cartCount: Int = 0
    var onCart: () -> Void = {}

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Image.appLogo
                .resizable()
                .scaledToFit()
                .frame(height: 32)
                .padding(.vertical, 12)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: onCart) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "cart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.appBlack)
                        .padding(.vertical, 12)

                    if cartCount > 0 {
                        Text("\(cartCount)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.appWhite)
                            .padding(3)
                            .background(Color.appRed)
                            .clipShape(Circle())
                            .offset(x: 8, y: 2)
                    }
                }
            }
        }
    }
}

extension View {
    func customToolbar(cartCount: Int = 0, onCart: @escaping () -> Void = {}) -> some View {
        self.toolbar {
            CustomToolbar(cartCount: cartCount, onCart: onCart)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
