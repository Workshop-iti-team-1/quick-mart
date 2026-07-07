//
//  InsightsView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//
//
//  InsightsView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

struct InsightsView: View {
    @StateObject var viewModel: InsightsViewModel
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 0) {
            appBar

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header card
                    headerSection

                    if viewModel.isLoading {
                        loadingSection
                    } else if let result = viewModel.resultText {
                        insightsSection(result)
                    } else if let error = viewModel.errorMessage {
                        errorSection(error)
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .onAppear { viewModel.loadInsights() }
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
                Image(systemName: "chart.bar.xaxis.ascending")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.cyanPrimary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Your Shopping Insights")
                    .appTextStyle(.label, color: .appBlack)
                Text("Personalized analysis of your order history")
                    .appTextStyle(.caption, color: .grayText)
            }
            Spacer()
        }
    }

    // MARK: - Loading
    private var loadingSection: some View {
        VStack(spacing: 16) {
            AILoadingView(message: "Analyzing your orders...")
            SkeletonTextBlock(lineCount: 3)
            SkeletonTextBlock(lineCount: 2)
        }
    }

    // MARK: - Insights
    private func insightsSection(_ text: String) -> some View {
        let items = parseInsightItems(text)

        return VStack(alignment: .leading, spacing: 12) {
            ForEach(items) { item in
                insightCard(item)
            }

            // Powered by
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 10))
                    Text("Powered by Gemini")
                        .font(.system(size: 10))
                }
                .foregroundColor(.grey150)
                Spacer()
            }
            .padding(.top, 8)
        }
        .transition(.opacity)
    }

    private func insightCard(_ item: InsightItem) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.accentColor.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: item.icon)
                    .font(.system(size: 16))
                    .foregroundColor(item.accentColor)
            }

            // Content
            Text(item.text)
                .appTextStyle(.body, color: .appBlack)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(14)
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
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.cyanPrimary)
                Text("Shopping Insights")
                    .appTextStyle(.heading2, color: .appBlack)
            }
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Parsing
    private func parseInsightItems(_ text: String) -> [InsightItem] {
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        return lines.enumerated().map { index, line in
            let cleaned = line
                .replacingOccurrences(of: #"\*\*(.+?)\*\*"#, with: "$1", options: .regularExpression)
                .replacingOccurrences(of: #"^[-•*]\s*"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"^\d+[\.\)]\s*"#, with: "", options: .regularExpression)

            let lower = cleaned.lowercased()
            let icon: String
            let color: Color

            if lower.contains("spend") || lower.contains("price") || lower.contains("budget") || lower.contains("total") || lower.contains("cost") {
                icon = "dollarsign.circle.fill"
                color = .appMerigold
            } else if lower.contains("brand") || lower.contains("vendor") || lower.contains("store") {
                icon = "building.2.fill"
                color = .appPurple
            } else if lower.contains("suggest") || lower.contains("try") || lower.contains("recommend") || lower.contains("consider") || lower.contains("tip") {
                icon = "lightbulb.fill"
                color = .appYellow
            } else if lower.contains("categor") || lower.contains("type") || lower.contains("style") || lower.contains("prefer") || lower.contains("favor") {
                icon = "tag.fill"
                color = .cyanPrimary
            } else {
                icon = "chart.line.uptrend.xyaxis"
                color = .appBlue
            }

            return InsightItem(id: index, text: cleaned, icon: icon, accentColor: color)
        }
    }
}

// MARK: - Supporting Types
private struct InsightItem: Identifiable {
    let id: Int
    let text: String
    let icon: String
    let accentColor: Color
}
