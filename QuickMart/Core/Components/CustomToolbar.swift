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
                        .padding(.trailing, 14)
                        .padding(.top, 4)
                        
                    if cartCount > 0 {
                        Text("\(cartCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .frame(minWidth: 16, minHeight: 16)
                            .background(Color.cyanPrimary)
                            .clipShape(Capsule())
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
