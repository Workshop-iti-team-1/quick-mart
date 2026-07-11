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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.black.opacity(colorScheme == .dark ? 0.6 : 0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Animated Shimmering Icon
                ZStack {
                    Circle()
                        .fill(Color.cyanPrimary.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .stroke(Color.cyanPrimary.opacity(0.3), lineWidth: 2)
                        .frame(width: 80, height: 80)
                        
                    Image(systemName: "hourglass")
                        .font(.system(size: 32))
                        .foregroundColor(.cyanPrimary)
                        .shimmer()
                }
                
                VStack(spacing: 8) {
                    Text(message ?? "Authenticating...")
                        .appTextStyle(.heading3, color: .appBlack)
                        .multilineTextAlignment(.center)
                        
                    Text("Please wait a moment")
                        .appTextStyle(.caption, color: .grayText)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 32)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.grey100.opacity(colorScheme == .dark ? 0.1 : 0.5), lineWidth: 1)
            )
        }
    }
}
