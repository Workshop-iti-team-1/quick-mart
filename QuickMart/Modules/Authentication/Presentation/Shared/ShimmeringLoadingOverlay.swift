//
//  ShimmeringLoadingOverlay.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 07/07/2026.
//
import SwiftUI

// Dedicated Shimmering Loading Overlay
struct ShimmeringLoadingOverlay: View {
    let message: String?
    var body: some View {
        ZStack {
            Color.appBlack.opacity(0.3).ignoresSafeArea()  // Dim the background

            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appWhite)
                    .frame(width: 200, height: 60)
                    .shimmer()  // Uses your View+Shimmer modifier

                Text(message ?? "Authenticating...")
                    .appTextStyle(.label, color: .appWhite)
            }
        }
    }
}
