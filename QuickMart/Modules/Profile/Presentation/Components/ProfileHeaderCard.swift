//
//  ProfileHeaderCard.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.

import SwiftUI

struct ProfileHeaderCard: View {
    
    let name: String
    let email: String
    let avatarImageURL: String?
    var onLogoutTap: (() -> Void)? = nil

    var body: some View {
        
        HStack(spacing: 12) {
        
            avatarView
            VStack(alignment: .leading, spacing: 2) {
                Text(name).appTextStyle(.button, color: .appWhite)
                Text(email).appTextStyle(.caption, color: .appWhite.opacity(0.85))
            }
            Spacer()
            Button { onLogoutTap?() } label: {
                Image("logout").font(.system(size: 22)).foregroundColor(.appWhite)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.cyanPrimary))
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var avatarView: some View {
        
        if let profileImageUrl = avatarImageURL, UIImage(named: profileImageUrl) != nil {
        
            Image(profileImageUrl).resizable().scaledToFill().frame(width: 48, height: 48).clipShape(Circle())
        } else {
            
            Circle().fill(Color.appWhite.opacity(0.3)).frame(width: 48, height: 48)
                .overlay(Image(systemName: "person.fill").foregroundColor(.appWhite))
        }
    }
}

#Preview {
    ProfileHeaderCard(
        name: "Ahmed El-Sayyad",
        email: "ahmed@example.com",
        avatarImageURL: nil,
        onLogoutTap: { print("Logout tapped") }
    )
    .background(Color.black.opacity(0.05))
}
