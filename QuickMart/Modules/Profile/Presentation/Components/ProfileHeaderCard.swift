//
//  ProfileHeaderCard.swift
//  QuickMart
//
//  Created by Ahmed El-Sayyad Mohamed on 02/07/2026.
import SwiftUI

struct ProfileHeaderCard: View {
    let user: UserEntity
    var onLogoutTap: (() -> Void)? = nil
    var onInfoTap: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
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
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                onLogoutTap?()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.appRed.opacity(0.2))
                        .frame(width: 40, height: 40)
                    Image("logout")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.appRed)
                }
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
                    ProgressView().frame(width: 52, height: 52)
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
