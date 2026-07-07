//
//  AILoadingView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//


//
//  AILoadingView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 06/07/2026.
//

import SwiftUI

// MARK: - AI Loading View
/// A premium animated loading indicator for AI-powered features.
/// Shows a pulsing sparkle icon with bouncing dots and a contextual message.
struct AILoadingView: View {
    var message: String = "Analyzing..."
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            // Animated sparkle icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.cyanPrimary.opacity(0.15), Color.cyan50.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)

                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyanPrimary, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .rotationEffect(.degrees(isAnimating ? 8 : -8))
            }
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)

            // Pulsing dots
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.cyanPrimary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.0 : 0.4)
                        .opacity(isAnimating ? 1.0 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }

            Text(message)
                .appTextStyle(.caption, color: .grayText)
        }
        .padding(.vertical, 32)
        .onAppear { isAnimating = true }
    }
}

// MARK: - Compact Loading (for inline use)
/// A smaller loading indicator for inline contexts like chat typing indicators.
struct AICompactLoading: View {
    var message: String? = nil
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.cyanPrimary)
                        .frame(width: 6, height: 6)
                        .offset(y: isAnimating ? -4 : 4)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.15),
                            value: isAnimating
                        )
                }
            }
            if let message {
                Text(message)
                    .appTextStyle(.caption, color: .grayText)
            }
        }
        .onAppear { isAnimating = true }
    }
}

// MARK: - Shimmer Modifier
/// Adds a sweeping shimmer/shine animation to any view, typically used on skeleton placeholders.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .white.opacity(0.35),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: phase * geo.size.width)
                    .onAppear {
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            phase = 1.6
                        }
                    }
                }
            )
            .clipped()
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Skeleton Product Card
/// A placeholder card that mimics the AIProductCard layout while content loads.
struct SkeletonProductCard: View {
    var width: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grey100.opacity(0.4))
                .frame(height: 130)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.grey100.opacity(0.4))
                .frame(height: 14)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.grey100.opacity(0.4))
                .frame(width: 70, height: 10)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.grey100.opacity(0.4))
                .frame(width: 60, height: 10)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.grey100.opacity(0.4))
                .frame(width: 80, height: 14)
        }
        .padding(10)
        .frame(width: width)
        .background(Color.backGround)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.grey100.opacity(0.4), lineWidth: 1)
        )
        .shimmer()
    }
}

// MARK: - Skeleton Text Block
/// A placeholder for text-heavy AI result cards while the model generates a response.
struct SkeletonTextBlock: View {
    var lineCount: Int = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.grey100.opacity(0.4))
                    .frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.grey100.opacity(0.4))
                    .frame(width: 140, height: 16)
            }

            ForEach(0..<lineCount, id: \.self) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.grey100.opacity(0.4))
                    .frame(height: 12)
                    .frame(maxWidth: i == lineCount - 1 ? 200 : .infinity)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.grey50)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shimmer()
    }
}

// MARK: - Skeleton Outfit Item
/// A placeholder row mimicking a single outfit suggestion while the AI generates.
struct SkeletonOutfitItem: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grey100.opacity(0.4))
                .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.grey100.opacity(0.4))
                    .frame(height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.grey100.opacity(0.4))
                    .frame(width: 140, height: 10)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.grey50)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shimmer()
    }
}