//
//  CustomLoadingView.swift
//  QuickMart
//
//  Created by siam on 28/06/2026.
//

import SwiftUI

struct CustomLoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .cyanPrimary))
                .scaleEffect(1.5)
                .padding(24)
                .background(Color.backGround)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zIndex(999)
    }
}
