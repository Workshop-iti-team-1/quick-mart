//
//  PaymentMethodSectionView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import SwiftUI

struct PaymentMethodSectionView: View {

    @Binding var selectedMethod: PaymentMethod

    private enum Layout {
        static let cornerRadius: CGFloat  = 12
        static let padding: CGFloat       = 16
        static let spacing: CGFloat       = 12
        static let iconSize: CGFloat      = 36
        static let shadowOpacity: Double  = 0.06
        static let shadowRadius: CGFloat  = 4
        static let shadowY: CGFloat       = 2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            Text("Payment Method")
                .appTextStyle(.heading2, color: .appBlack)

            ForEach(PaymentMethod.allCases) { method in
                paymentCard(for: method)
            }
        }
    }

    // MARK: - Payment Card

    private func paymentCard(for method: PaymentMethod) -> some View {
        let isSelected = selectedMethod == method

        return Button {
            selectedMethod = method
        } label: {
            HStack(spacing: 12) {
                // Method icon
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.cyan50 : Color.grey50)
                        .frame(
                            width: Layout.iconSize,
                            height: Layout.iconSize
                        )
                    Image(systemName: method.iconName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(
                            isSelected ? .cyanPrimary : .grey150
                        )
                }

                // Method name
                Text(method.rawValue)
                    .appTextStyle(
                        .label,
                        color: isSelected ? .appBlack : .grey150
                    )

                Spacer(minLength: 0)

                // Radio indicator
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? Color.cyanPrimary : Color.grey150,
                            lineWidth: 1.5
                        )
                        .frame(width: 20, height: 20)

                    if isSelected {
                        Circle()
                            .fill(Color.cyanPrimary)
                            .frame(width: 11, height: 11)
                    }
                }
                .animation(.easeInOut(duration: 0.15), value: isSelected)
            }
            .padding(Layout.padding)
            .background(
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .fill(Color.cardBackground)
                    .shadow(
                        color: Color.appBlack.opacity(Layout.shadowOpacity),
                        radius: Layout.shadowRadius,
                        x: 0,
                        y: Layout.shadowY
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: Layout.cornerRadius)
                            .stroke(
                                isSelected
                                    ? Color.cyanPrimary
                                    : Color.clear,
                                lineWidth: 1.5
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var method: PaymentMethod = .applePay
    PaymentMethodSectionView(selectedMethod: $method)
        .padding(16)
        .background(Color.backGround)
}
