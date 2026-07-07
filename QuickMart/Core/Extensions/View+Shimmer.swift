//
//  View+Shimmer.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 27/06/2026.
//
import SwiftUI

struct ShimmerEffect: ViewModifier {
    @State private var isInitialState = true

    func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .black.opacity(0.4),
                        .black,
                        .black.opacity(0.4)
                    ]),
                    startPoint: isInitialState ? .init(x: -0.3, y: -0.3) : .init(x: 1, y: 1),
                    endPoint: isInitialState ? .init(x: 0, y: 0) : .init(x: 1.3, y: 1.3)
                )
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    isInitialState = false
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
