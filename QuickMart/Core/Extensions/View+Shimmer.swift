//
//  View+Shimmer.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import SwiftUI

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = -0.5

    func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black.opacity(0.4), location: phase - 0.2),
                        .init(color: .black, location: phase),
                        .init(color: .black.opacity(0.4), location: phase + 0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1.5
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerEffect())
    }
    
    @ViewBuilder
    func applySkeleton(if isLoading: Bool) -> some View {
        if isLoading {
            self
                .redacted(reason: .placeholder)
                .shimmer()
        } else {
            self
        }
    }
}
