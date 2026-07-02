//
//  ProductOptionsView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductOptionsView: View {
    let product: ProductDetails
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        ForEach(product.options, id: \.id) { option in
            if option.name.lowercased() == "color" && !option.values.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(AppStrings.ProductDetails.color)
                        .appTextStyle(.button, color: Color.appBlack)
                    
                    HStack(spacing: 12) {
                        ForEach(option.values, id: \.self) { colorName in
                            Circle()
                                .fill(getColor(for: colorName))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle().stroke(Color.appBlack, lineWidth: viewModel.selectedColor == colorName ? 2 : 0)
                                )
                                .onTapGesture {
                                    viewModel.selectedColor = colorName
                                }
                        }
                    }
                }
            } else if !option.values.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text(option.name)
                        .appTextStyle(.button, color: Color.appBlack)
                    
                    HStack(spacing: 12) {
                        ForEach(option.values, id: \.self) { val in
                            Text(val.uppercased())
                                .appTextStyle(.label, color: viewModel.selectedSize == val ? Color.appWhite : Color.appBlack)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(viewModel.selectedSize == val ? Color.appBlack : Color.appWhite)
                                )
                                .overlay(
                                    Capsule().stroke(Color.grey100, lineWidth: viewModel.selectedSize == val ? 0 : 1)
                                )
                                .onTapGesture {
                                    viewModel.selectedSize = val
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func getColor(for name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "gray", "grey": return .gray
        case "brown": return .brown
        case "cyan": return .cyan
        case "pink": return .pink
        case "silver": return Color(white: 0.8)
        case "gold": return Color(red: 1.0, green: 0.84, blue: 0.0)
        default: return .gray
        }
    }
}
