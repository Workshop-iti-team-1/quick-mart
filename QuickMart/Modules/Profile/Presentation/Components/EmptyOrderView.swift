//
//  EmptyOrderView.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import SwiftUI

struct EmptyOrderView: View {
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Image
            Image.noOrders
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            VStack(spacing: 8) {
                Text(isCompleted ? AppStrings.Profile.noCompletedOrder : AppStrings.Profile.noOngoingOrder)
                    .appTextStyle(.heading2, color: .primary)
                
                Text(isCompleted ? AppStrings.Profile.noCompletedOrderDesc : AppStrings.Profile.noOngoingOrderDesc)
                    .appTextStyle(.body, color: .gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: {
                // Navigate to home or categories
            }) {
                Text(AppStrings.Profile.exploreCategories)
                    .appTextStyle(.button, color: .appWhite)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyanPrimary)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}
