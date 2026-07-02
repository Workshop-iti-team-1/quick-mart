//
//  CartItemRowView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct CartItemRowView: View {
    let item: CartLine
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Image
            ZStack {
                Color.gray.opacity(0.1)
                
                if let imageUrl = item.merchandise.imageURL, let url = URL(string: imageUrl) {
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
                HStack(alignment: .top) {
                    Text(item.merchandise.productTitle)
                        .appTextStyle(.body, color: .primary)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    // Selection checkmark (Mocked as always selected for now)
                    Image(systemName: "checkmark.square.fill")
                        .foregroundColor(.cyanPrimary)
                }
                
                Text(item.merchandise.title) // Variant title
                    .appTextStyle(.body, color: .gray)
                    .font(.system(size: 12))
                
                Text("\(item.merchandise.price, specifier: "%.2f") \(item.cost.currencyCode)")
                    .appTextStyle(.label, color: .primary)
                
                if let comparePrice = item.merchandise.compareAtPrice, comparePrice > item.merchandise.price {
                    Text("\(comparePrice, specifier: "%.2f") \(item.cost.currencyCode)")
                        .strikethrough()
                        .appTextStyle(.body, color: .gray)
                        .font(.system(size: 12))
                }
                
                HStack {
                    // Stepper
                    HStack(spacing: 16) {
                        Button(action: onDecrement) {
                            Image(systemName: "minus")
                                .foregroundColor(.primary)
                        }
                        
                        Text("\(item.quantity)")
                            .appTextStyle(.body, color: .primary)
                        
                        Button(action: onIncrement) {
                            Image(systemName: "plus")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    // Delete Button
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(8)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}
