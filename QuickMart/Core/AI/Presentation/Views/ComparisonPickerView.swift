//
//  ComparisonPickerView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

//
//  ComparisonPickerView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct ComparisonPickerView: View {
    let baseProduct: ProductDetails
    @ObservedObject private var favouriteViewModel = FavouriteViewModel.shared
    @Environment(AppRouter.self) private var router
    @State private var selectedIDs: Set<String> = []

    private var candidateProducts: [(id: String, title: String, imageURL: String?)] {
        favouriteViewModel.favorites
            .filter { $0.id != baseProduct.id }
            .map { ($0.id, $0.title, $0.imageURL) }
    }

    var body: some View {
        VStack(spacing: 0) {
            appBar

            if candidateProducts.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        // Base product header
                        baseProductHeader
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, 16)

                        // Selection hint
                        HStack {
                            Text("Select up to 2 items to compare")
                                .appTextStyle(.caption, color: .grayText)
                            Spacer()
                            Text("\(selectedIDs.count)/2 selected")
                                .appTextStyle(.caption, color: .cyanPrimary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)

                        // Candidate list
                        LazyVStack(spacing: 0) {
                            ForEach(candidateProducts, id: \.id) { item in
                                candidateRow(item)
                                if item.id != candidateProducts.last?.id {
                                    Divider()
                                        .padding(.leading, 76)
                                }
                            }
                        }
                    }
                }

                // Compare button
                AppButton(title: "Compare (\(selectedIDs.count + 1) items)", icon: "sparkles") {
                    let chosen = selectedIDs.compactMap { id in
                        favouriteViewModel.getCachedProduct(id: id)
                    }
                    router.push(.aiComparison(products: [baseProduct] + chosen))
                }
                .disabled(selectedIDs.isEmpty)
                .padding(16)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .onAppear { favouriteViewModel.loadFavorites() }
    }

    // MARK: - Base Product Header
    private var baseProductHeader: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: baseProduct.images.first?.url ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit().transition(.opacity)
                default:
                    Image(systemName: "photo")
                        .font(.system(size: 16))
                        .foregroundColor(.grey150)
                }
            }
            .frame(width: 48, height: 48)
            .background(Color.grey50)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text("Comparing against")
                    .appTextStyle(.caption, color: .cyanPrimary)
                Text(baseProduct.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 20))
                .foregroundColor(.cyanPrimary)
        }
        .padding(12)
        .background(Color.cyan50.opacity(0.4))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.cyanPrimary.opacity(0.15), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Candidate Row
    private func candidateRow(_ item: (id: String, title: String, imageURL: String?)) -> some View {
        let isSelected = selectedIDs.contains(item.id)

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                if isSelected {
                    selectedIDs.remove(item.id)
                } else if selectedIDs.count < 2 {
                    selectedIDs.insert(item.id)
                }
            }
        } label: {
            HStack(spacing: 12) {
                // Thumbnail
                AsyncImage(url: URL(string: item.imageURL ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit().transition(.opacity)
                    default:
                        Image(systemName: "photo")
                            .font(.system(size: 14))
                            .foregroundColor(.grey150)
                    }
                }
                .frame(width: 44, height: 44)
                .background(Color.grey50)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Title
                Text(item.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.cyanPrimary : Color.grey150, lineWidth: 1.5)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(Color.cyanPrimary)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isSelected ? Color.cyan50.opacity(0.25) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.grey50)
                    .frame(width: 80, height: 80)
                Image(systemName: "heart.slash")
                    .font(.system(size: 32))
                    .foregroundColor(.grey150)
            }
            Text("No items to compare")
                .appTextStyle(.label, color: .appBlack)
            Text("Add a few items to your wishlist first to compare them.")
                .appTextStyle(.body, color: .grayText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }

    // MARK: - App Bar
    private var appBar: some View {
        HStack {
            Spacer()
            Text("Select Items to Compare")
                .appTextStyle(.heading2, color: .appBlack)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
