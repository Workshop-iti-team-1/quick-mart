//
//  WishlistView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//
//

import SwiftUI

struct WishlistView: View {
    @ObservedObject private var viewmodel = FavouriteViewModel.shared
    @Environment(AppRouter.self) private var router

    @State private var favoritePendingDelete: FavoriteProduct?
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            if viewmodel.favorites.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewmodel.favorites) { favorite in
                        WishlistRowView(favorite: favorite)
                            .contentShape(Rectangle())
                            .onTapGesture { openDetail(favorite) }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    favoritePendingDelete = favorite
                                    showDeleteAlert = true
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .background(Color.backGround)
                .padding(.top, 8)
            }
        }
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Remove from Wishlist?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                favoritePendingDelete = nil
            }
            Button("Remove", role: .destructive) {
                if let favorite = favoritePendingDelete {
                    viewmodel.removeFavorite(id: favorite.id)
                }
                favoritePendingDelete = nil
            }
        } message: {
            Text("Are you sure you want to remove \"\(favoritePendingDelete?.title ?? "this item")\" from your wishlist?")
        }
        .alert("Error", isPresented: .constant(viewmodel.errorMessage != nil)) {
            Button("OK") { viewmodel.errorMessage = nil }
        } message: {
            Text(viewmodel.errorMessage ?? "")
        }
        .onAppear { viewmodel.loadFavorites() }
    }

    private func openDetail(_ favorite: FavoriteProduct) {
        guard let cached = viewmodel.getCachedProduct(id: favorite.id) else { return }
        router.push(.favoriteDetail(cached))
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.cyan50)
                    .frame(width: 120, height: 120)
                Image(systemName: "heart.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.cyanPrimary)
            }

            VStack(spacing: 8) {
                Text("Your wishlist is empty")
                    .appTextStyle(.heading2, color: .appBlack)
                Text("Save items you love and find them here anytime, even offline.")
                    .appTextStyle(.body, color: .grayText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            AppButton(title: "Start Shopping", icon: "bag.fill") {
                router.switchTab(to: .home)
            }
            .padding(.horizontal, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 60)
    }
}
