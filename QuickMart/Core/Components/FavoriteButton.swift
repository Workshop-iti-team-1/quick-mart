//
//  FavoriteButton.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//


//
//  FavoriteButton.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//

import SwiftUI
struct FavoriteButton: View {
    @Binding var isFavorite: Bool

    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .appRed : .grey150)
                .font(.system(size: 18, weight: .medium))
                .padding(6)
                .background(Color.appWhite)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}
