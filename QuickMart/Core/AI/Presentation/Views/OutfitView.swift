//
//  OutfitView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
//
//  OutfitView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct OutfitView: View {
    @StateObject var viewModel: OutfitViewModel
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 0) {
            appBar
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    heroSection

                    if viewModel.isLoading {
                        loadingSection
                    } else if !viewModel.suggestions.isEmpty {
                        suggestionsSection
                    } else if let error = viewModel.errorMessage {
                        errorSection(error)
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .tint(.cyanPrimary)
        .onAppear { viewModel.generate() }
    }

    // MARK: - Hero
    private var heroSection: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: viewModel.product.images.first?.url ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .transition(.opacity)
                case .failure:
                    Image(systemName: "tshirt").font(.system(size: 28)).foregroundColor(.grey150)
                default:
                    ProgressView().tint(.cyanPrimary)
                }
            }
            .frame(width: 90, height: 90)
            .background(Color.grey50)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(LinearGradient(colors: [.cyanPrimary.opacity(0.4), .cyan.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
            )
            .shadow(color: .cyanPrimary.opacity(0.1), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles").font(.system(size: 11)).foregroundColor(.cyanPrimary)
                    Text("Styling around").appTextStyle(.caption, color: .cyanPrimary)
                }
                Text(viewModel.product.title).appTextStyle(.label, color: .appBlack).lineLimit(2)
                Text(viewModel.product.vendor).appTextStyle(.caption, color: .grayText)
                HStack(spacing: 3) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundColor(.appYellow)
                    Text(String(format: "%.1f", viewModel.product.rating)).appTextStyle(.caption, color: .grayText)
                }
            }
            Spacer()
        }
        .padding(14)
        .background(Color.cyan50.opacity(0.4))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cyanPrimary.opacity(0.12), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Loading
    private var loadingSection: some View {
        VStack(spacing: 16) {
            AILoadingView(message: "Finding real pieces to match...")
            ForEach(0..<3, id: \.self) { _ in SkeletonOutfitItem() }
        }
    }

    // MARK: - Suggestions (real products)
    private var suggestionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(LinearGradient(colors: [.cyanPrimary, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text("Complete Your Look").appTextStyle(.label, color: .appBlack)
                Spacer()
                Text("\(viewModel.suggestions.count) pieces").appTextStyle(.caption, color: .grayText)
            }

            ForEach(viewModel.suggestions) { suggestion in
                Button {
                    router.push(.productDetails(productId: suggestion.id))
                } label: {
                    OutfitSuggestionCard(suggestion: suggestion)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundColor(.cyanPrimary)
                Text("These are real QuickMart products — tap any item to view it.")
                    .appTextStyle(.caption, color: .grayText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cyan50.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func errorSection(_ error: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.appRed)
            Text(error).appTextStyle(.body, color: .appRed).fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appRed.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - App Bar
    private var appBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.cyanPrimary)
                Text("Complete the Look")
                    .appTextStyle(.heading2, color: .appBlack)
            }
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

// MARK: - Outfit Suggestion Card (real product)
private struct OutfitSuggestionCard: View {
    let suggestion: OutfitProductSuggestion
    @EnvironmentObject var currencyManager: CurrencyManagerService

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.grey50)
                    .frame(width: 60, height: 60)
                    .overlay(productImage)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(suggestion.category.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.cyanPrimary)
                    Text(suggestion.product.name)
                        .appTextStyle(.label, color: .appBlack)
                        .lineLimit(2)
                    Text(currencyManager.format(defultAppCurrency: suggestion.product.price))
                        .appTextStyle(.caption, color: .cyanPrimary)
                }

                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.grey150)
            }

            Text(suggestion.reason)
                .appTextStyle(.caption, color: .grayText)
                .padding(.top, 8)
                .padding(.leading, 72)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(Color.grey50)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.grey100, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var productImage: some View {
        Group {
            if suggestion.product.isSystemImage {
                Image(systemName: suggestion.product.imageName).foregroundColor(.grey150)
            } else if let url = URL(string: suggestion.product.imageName) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFit().padding(6)
                    default: Image(systemName: "photo").foregroundColor(.grey150)
                    }
                }
            } else {
                Image(systemName: "photo").foregroundColor(.grey150)
            }
        }
    }
}
