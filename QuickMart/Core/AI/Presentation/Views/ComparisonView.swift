//
//  AIProductCard.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

//
//  ComparisonView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct ComparisonView: View {
    @StateObject var viewModel: ComparisonViewModel
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 0) {
            appBar

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header chip
                    headerSection

                    // Product cards with VS dividers
                    productsSection

                    // AI Result / Loading / Error
                    if viewModel.isLoading {
                        loadingSection
                    } else if let result = viewModel.resultText {
                        aiResultSection(result)
                    } else if let error = viewModel.errorMessage {
                        errorSection(error)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { viewModel.compare() }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.cyanPrimary.opacity(0.15), Color.cyan50.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.cyanPrimary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Smart Comparison")
                    .appTextStyle(.label, color: .appBlack)
                Text("Comparing \(viewModel.products.count) products side by side")
                    .appTextStyle(.caption, color: .grayText)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Products Carousel
    private var productsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, product in
                    Button {
                        router.push(.productDetails(productId: product.id))
                    } label: {
                        AIProductCard(product: product, isHighlighted: index == 0, size: .large)
                    }
                    .buttonStyle(.plain)

                    if index < viewModel.products.count - 1 {
                        vsDivider
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
    }

    private var vsDivider: some View {
        Text("VS")
            .font(.system(size: 11, weight: .heavy, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.cyanPrimary, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .cyanPrimary.opacity(0.25), radius: 6, x: 0, y: 3)
            )
            .padding(.horizontal, 6)
    }

    // MARK: - Loading
    private var loadingSection: some View {
        VStack(spacing: 16) {
            AILoadingView(message: "Comparing products for you...")
            SkeletonTextBlock(lineCount: 5)
                .padding(.horizontal, 16)
        }
        .transition(.opacity)
    }

    // MARK: - AI Result
    private func aiResultSection(_ text: String) -> some View {
        let sections = parseResultSections(text)

        return VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyanPrimary, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text("AI Analysis")
                    .appTextStyle(.label, color: .cyanPrimary)
                Spacer()
                Text("Powered by Gemini")
                    .font(.system(size: 10))
                    .foregroundColor(.grey150)
            }
            .padding(.horizontal, 16)

            // Result card
            VStack(alignment: .leading, spacing: 10) {
                ForEach(sections) { section in
                    if section.isRecommendation {
                        // Recommendation highlight card
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.appYellow)
                                .frame(width: 22)
                            Text(section.content)
                                .appTextStyle(.label, color: .appBlack)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appYellow.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        // Regular bullet point
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Color.cyanPrimary.opacity(0.6))
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)
                            Text(section.content)
                                .appTextStyle(.body, color: .appBlack)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.grey50)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cyanPrimary.opacity(0.12), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
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
        .padding(.horizontal, 16)
    }

    // MARK: - App Bar
    private var appBar: some View {
        HStack {
            Button(action: { router.pop() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appBlack)
                    .frame(width: 40, height: 40)
                    .background(Color.grey50)
                    .clipShape(Circle())
            }
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14))
                    .foregroundColor(.cyanPrimary)
                Text("AI Comparison")
                    .appTextStyle(.heading2, color: .appBlack)
            }
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    // MARK: - Parser Helpers
    private func parseResultSections(_ text: String) -> [ResultSection] {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        return lines.enumerated().map { index, line in
            // Strip common markdown / list prefixes
            let cleaned = line
                .replacingOccurrences(of: #"\*\*(.+?)\*\*"#, with: "$1", options: .regularExpression)
                .replacingOccurrences(of: #"^[-•*]\s*"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"^\d+[\.\)]\s*"#, with: "", options: .regularExpression)

            let lower = cleaned.lowercased()
            let isRec = lower.contains("recommend") || lower.contains("winner") ||
                        lower.contains("verdict") || lower.contains("best overall") ||
                        lower.contains("final pick") || lower.contains("go with")

            return ResultSection(id: index, content: cleaned, isRecommendation: isRec)
        }
    }
}

// MARK: - Supporting Types
private struct ResultSection: Identifiable {
    let id: Int
    let content: String
    let isRecommendation: Bool
}
