//
//  FavoriteButton.swift
//  QuickMart
//
//  Created by Alaa Ayman on 29/06/2026.
//
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    var onToggle: ((Bool) -> Void)? = nil

    @Environment(AppRouter.self) private var router
    @State private var showGuestAlert = false

    var body: some View {
        Button {
            guard SessionManager.shared.currentState == .loggedIn else {
                showGuestAlert = true
                return
            }
            let newValue = !isFavorite   // compute once, before touching the binding
            isFavorite = newValue        // still a no-op setter where used that way — harmless
            onToggle?(newValue)          // always gets the CORRECT new value now
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .cyanPrimary : .grey150)
                .font(.system(size: 18, weight: .medium))
                .padding(6)
                .background(Color.cardBackground)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .alert("Login Required", isPresented: $showGuestAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log In") { router.push(.login) }
        } message: {
            Text("Please log in to save items to your wishlist.")
        }
    }
}
