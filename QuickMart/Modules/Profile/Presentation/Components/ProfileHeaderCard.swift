//
//  ProfileHeaderCard.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.

import SwiftUI

struct ProfileHeaderCard: View {
    
    let user: UserEntity
    var onLogoutTap: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            avatarView
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name ?? "Unknown")
                    .appTextStyle(.button, color: .appWhite)
                
                Text(user.email ?? "Unknown")
                    .appTextStyle(.button, color: .appWhite)
            }
            
            Spacer()
            
            Button {
                onLogoutTap?()
            } label: {
                Image("logout")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.appWhite)
            }
        }
        .padding(16)
    }

    @ViewBuilder
    private var avatarView: some View {
        if let urlString = user.avatarImageURL, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 48, height: 48)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.appWhite.opacity(0.3))
            .frame(width: 48, height: 48)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(.appWhite)
            )
    }
}
