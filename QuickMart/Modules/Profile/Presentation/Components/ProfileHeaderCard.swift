//
//  ProfileHeaderCard.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.

import SwiftUI

struct ProfileHeaderCard: View {
    let user: UserEntity
    var onInfoTap: (() -> Void)? = nil

    var body: some View {
        Button {
            onInfoTap?()
        } label: {
            HStack(spacing: 12) {
                avatarView

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name ?? "Unknown")
                        .appTextStyle(.button, color: .appWhite)
                    Text(user.email ?? "Unknown")
                        .appTextStyle(.caption, color: .appWhite.opacity(0.85))
                }

                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(16)
    }

    @ViewBuilder
    private var avatarView: some View {
        if let urlString = user.avatarImageURL, let url = URL(string: urlString)
        {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.shimmerBase)
                        .frame(width: 52, height: 52)
                        .shimmer()
                case .success(let image):
                    image.resizable().scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.appWhite.opacity(0.25))
            .frame(width: 52, height: 52)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.appWhite)
            )
    }
}
