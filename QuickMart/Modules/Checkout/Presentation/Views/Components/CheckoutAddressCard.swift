//
//  CheckoutAddressCard.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 05/07/2026.
//

import SwiftUI

struct CheckoutAddressCard: View {

    let selectedAddress: Address?
    let onChangeTap: () -> Void

    private enum Layout {
        static let cornerRadius: CGFloat  = 12
        static let padding: CGFloat       = 16
        static let iconSize: CGFloat      = 36
        static let shadowOpacity: Double  = 0.06
        static let shadowRadius: CGFloat  = 4
        static let shadowY: CGFloat       = 2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader
            cardContent
        }
    }

    // MARK: - Header

    private var sectionHeader: some View {
        HStack {
            Text("Shipping Address")
                .appTextStyle(.heading2, color: .appBlack)
            Spacer()
            Button(action: onChangeTap) {
                Text(selectedAddress == nil ? "Add" : "Change")
                    .appTextStyle(.label, color: .cyanPrimary)
            }
        }
    }

    // MARK: - Card

    @ViewBuilder
    private var cardContent: some View {
        if let address = selectedAddress {
            filledCard(address: address)
        } else {
            emptyCard
        }
    }

    private func filledCard(address: Address) -> some View {
        HStack(spacing: 12) {
            // Location icon
            ZStack {
                Circle()
                    .fill(Color.cyan50)
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.cyanPrimary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(address.fullName)
                    .appTextStyle(.label, color: .appBlack)

                Text(address.formattedAddress)
                    .appTextStyle(.caption, color: .grey150)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                if let phone = address.phone, !phone.isEmpty {
                    Text(phone)
                        .appTextStyle(.caption, color: .grey150)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(Layout.padding)
        .background(cardBackground)
    }

    private var emptyCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.grey50)
                    .frame(width: Layout.iconSize, height: Layout.iconSize)
                Image(systemName: "mappin.slash")
                    .font(.system(size: 18))
                    .foregroundColor(.grey150)
            }

            Text("No address selected. Tap Add to continue.")
                .appTextStyle(.body, color: .grey150)

            Spacer(minLength: 0)
        }
        .padding(Layout.padding)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius)
            .fill(Color.cardBackground)
            .shadow(
                color: Color.appBlack.opacity(Layout.shadowOpacity),
                radius: Layout.shadowRadius,
                x: 0,
                y: Layout.shadowY
            )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        CheckoutAddressCard(
            selectedAddress: Address(
                id: "1",
                firstName: "John",
                lastName: "Doe",
                address1: "123 Main St",
                address2: nil,
                city: "New York",
                province: "NY",
                country: "United States",
                zip: "10001",
                phone: "+1 555 000 1234",
                isDefault: true
            ),
            onChangeTap: {}
        )

        CheckoutAddressCard(
            selectedAddress: nil,
            onChangeTap: {}
        )
    }
    .padding(16)
    .background(Color.backGround)
}
