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
                    // Hero product card
                    heroSection

                    // AI Suggestions / Loading / Error
                    if viewModel.isLoading {
                        loadingSection
                    } else if let result = viewModel.resultText {
                        suggestionsSection(result)
                    } else if let error = viewModel.errorMessage {
                        errorSection(error)
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .onAppear { viewModel.generate() }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        HStack(spacing: 14) {
            // Product image
            AsyncImage(url: URL(string: viewModel.product.images.first?.url ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .transition(.opacity)
                case .failure:
                    Image(systemName: "tshirt")
                        .font(.system(size: 28))
                        .foregroundColor(.grey150)
                default:
                    ProgressView()
                        .tint(.cyanPrimary)
                }
            }
            .frame(width: 90, height: 90)
            .background(Color.grey50)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        LinearGradient(
                            colors: [.cyanPrimary.opacity(0.4), .cyan.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: .cyanPrimary.opacity(0.1), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11))
                        .foregroundColor(.cyanPrimary)
                    Text("Styling around")
                        .appTextStyle(.caption, color: .cyanPrimary)
                }

                Text(viewModel.product.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)

                Text(viewModel.product.vendor)
                    .appTextStyle(.caption, color: .grayText)

                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundColor(.appYellow)
                    Text(String(format: "%.1f", viewModel.product.rating))
                        .appTextStyle(.caption, color: .grayText)
                }
            }

            Spacer()
        }
        .padding(14)
        .background(Color.cyan50.opacity(0.4))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cyanPrimary.opacity(0.12), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Loading
    private var loadingSection: some View {
        VStack(spacing: 16) {
            AILoadingView(message: "Creating your look...")

            ForEach(0..<3, id: \.self) { _ in
                SkeletonOutfitItem()
            }
        }
    }

    // MARK: - Suggestions
    private func suggestionsSection(_ text: String) -> some View {
        let items = parseOutfitItems(text)

        return VStack(alignment: .leading, spacing: 14) {
            // Section header
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyanPrimary, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("Complete Your Look")
                    .appTextStyle(.label, color: .appBlack)
                Spacer()
                Text("\(items.count) pieces")
                    .appTextStyle(.caption, color: .grayText)
            }

            // Suggestion cards
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                outfitItemCard(item, index: index + 1)
            }

            // Tip card
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.appYellow)
                Text("Search for any of these items in QuickMart to find matching products!")
                    .appTextStyle(.caption, color: .grayText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.appYellow.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func outfitItemCard(_ item: OutfitItem, index: Int) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Icon area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.cyanPrimary.opacity(0.12), Color.cyan50.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 52, height: 52)

                Image(systemName: outfitIcon(for: item.title))
                    .font(.system(size: 20))
                    .foregroundColor(.cyanPrimary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .appTextStyle(.label, color: .appBlack)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                if let reason = item.reason {
                    Text(reason)
                        .appTextStyle(.caption, color: .grayText)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)

            // Index badge
            Text("\(index)")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.cyanPrimary)
                .frame(width: 24, height: 24)
                .background(Color.cyanPrimary.opacity(0.1))
                .clipShape(Circle())
        }
        .padding(12)
        .background(Color.grey50)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.grey100, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Error
    private func errorSection(_ error: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.appRed)
            Text(error)
                .appTextStyle(.body, color: .appRed)
                .fixedSize(horizontal: false, vertical: true)
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

    // MARK: - Parsing Helpers

    /// Parses the free-form AI text into structured outfit items.
    /// Handles numbered lists (1. / 1) ), bullets (- / • / *), and markdown bold (**...**).
    private func parseOutfitItems(_ text: String) -> [OutfitItem] {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        var items: [OutfitItem] = []

        for (index, line) in lines.enumerated() {
            // Strip markdown bold, bullet prefixes, number prefixes
            let cleaned = line
                .replacingOccurrences(of: #"\*\*(.+?)\*\*"#, with: "$1", options: .regularExpression)
                .replacingOccurrences(of: #"^[-•*]\s*"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"^\d+[\.\)]\s*"#, with: "", options: .regularExpression)

            guard !cleaned.isEmpty else { continue }

            // Split into title and reason on first separator
            let separators = [" - ", " – ", ": ", " — "]
            var title = cleaned
            var reason: String? = nil

            for sep in separators {
                if let range = cleaned.range(of: sep) {
                    title = String(cleaned[cleaned.startIndex..<range.lowerBound])
                    reason = String(cleaned[range.upperBound...])
                    break
                }
            }

            items.append(OutfitItem(id: index, title: title, reason: reason))
        }

        return items
    }

    /// Maps common clothing keywords to SF Symbols for the item icon.
    private func outfitIcon(for title: String) -> String {
        let lower = title.lowercased()
        if lower.contains("shoe") || lower.contains("sneaker") || lower.contains("boot") ||
           lower.contains("loafer") || lower.contains("sandal") || lower.contains("heel") {
            return "shoe.fill"
        } else if lower.contains("watch") {
            return "watch.analog"
        } else if lower.contains("bag") || lower.contains("purse") || lower.contains("clutch") ||
                  lower.contains("backpack") || lower.contains("tote") {
            return "bag.fill"
        } else if lower.contains("hat") || lower.contains("cap") || lower.contains("beanie") {
            return "crown.fill"
        } else if lower.contains("glasses") || lower.contains("sunglasses") {
            return "eyeglasses"
        } else if lower.contains("belt") || lower.contains("scarf") || lower.contains("tie") ||
                  lower.contains("jewelry") || lower.contains("necklace") || lower.contains("bracelet") ||
                  lower.contains("earring") || lower.contains("ring") || lower.contains("accessori") {
            return "tag.fill"
        } else if lower.contains("pant") || lower.contains("jean") || lower.contains("trouser") ||
                  lower.contains("short") || lower.contains("skirt") || lower.contains("legging") {
            return "figure.walk"
        } else if lower.contains("jacket") || lower.contains("coat") || lower.contains("blazer") ||
                  lower.contains("hoodie") || lower.contains("cardigan") || lower.contains("sweater") {
            return "cloud.sun.fill"
        } else {
            return "tshirt.fill"
        }
    }
}

// MARK: - Supporting Types
private struct OutfitItem: Identifiable {
    let id: Int
    let title: String
    let reason: String?
}
