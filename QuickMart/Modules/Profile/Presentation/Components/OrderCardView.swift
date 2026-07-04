//
//  OrderCardView.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import SwiftUI

struct OrderCardView: View {
    let order: OrderEntity
    let item: OrderLineItemEntity
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, yyyy"
        return formatter.string(from: order.processedAt)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Badge
            HStack {
                Text(order.isCompleted ? AppStrings.Profile.finished : AppStrings.Profile.estimatedTime)
                    .appTextStyle(.label, color: .appWhite)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(order.isCompleted ? Color.cyanPrimary : Color.appRed)
                    .cornerRadius(8)
                
                Spacer()
                
                if order.isCompleted {
                    // Date
                    Text(formattedDate)
                        .appTextStyle(.label, color: .gray)
                }
            }
            
            HStack(alignment: .top, spacing: 12) {
                // Image
                ZStack {
                    Color.gray.opacity(0.1)
                    
                    if let imageUrl = item.imageURL, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 80, height: 80)
                .cornerRadius(12)
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .appTextStyle(.body, color: .primary)
                        .lineLimit(2)
                    
                    Text("\(item.originalTotalPrice, specifier: "%.2f") \(order.currencyCode)")
                        .appTextStyle(.label, color: .primary)
                    
                    HStack {
                        // Fake Stepper just to match UI
                        HStack(spacing: 16) {
                            Text("-")
                                .foregroundColor(.gray)
                            
                            Text("\(item.quantity)")
                                .appTextStyle(.body, color: .primary)
                            
                            Text("+")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(Color.backGround)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
