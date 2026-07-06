//
//  ProductDescriptionView.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import SwiftUI

struct ProductDescriptionView: View {
    let product: ProductDetails
    @State private var isExpanded = false
    @State private var canExpand = false
    
    @State private var fullHeight: CGFloat = 0
    @State private var limitedHeight: CGFloat = 0
    
    var body: some View {
        let cleanText = product.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        VStack(alignment: .leading, spacing: 8) {
            Text(cleanText)
                .appTextStyle(.body, color: Color.grey150)
                .lineLimit(isExpanded ? nil : 4)
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            limitedHeight = geo.size.height
                            updateTruncation()
                        }
                        .onChange(of: geo.size.height) { newHeight in
                            if !isExpanded {
                                limitedHeight = newHeight
                                updateTruncation()
                            }
                        }
                    }
                )
                .background(
                    Text(cleanText)
                        .appTextStyle(.body, color: Color.grey150)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(GeometryReader { geo in
                            Color.clear.onAppear {
                                fullHeight = geo.size.height
                                updateTruncation()
                            }
                            .onChange(of: geo.size.height) { newHeight in
                                fullHeight = newHeight
                                updateTruncation()
                            }
                        })
                        .hidden()
                )
            
            if canExpand {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? AppStrings.ProductDetails.readLess : AppStrings.ProductDetails.readMore)
                        .appTextStyle(.label, color: Color.cyanPrimary)
                }
            }
        }
    }
    
    private func updateTruncation() {
        if !isExpanded {
            if fullHeight > 0 && limitedHeight > 0 {
                // If the full text is taller than the 4-line limited text, it can be expanded.
                canExpand = fullHeight > limitedHeight
            }
        }
    }
}
