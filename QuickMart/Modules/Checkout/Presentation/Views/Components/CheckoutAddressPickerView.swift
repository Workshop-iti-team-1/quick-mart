//
//  CheckoutAddressPickerView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import SwiftUI

struct CheckoutAddressPickerView: View {

    let addresses: [Address]
    let selectedAddress: Address?
    let onSelect: (Address) -> Void
    let onAddNew: () -> Void

    @Environment(\.dismiss) private var dismiss

    private enum Layout {
        static let horizontalPad: CGFloat  = 16
        static let cornerRadius: CGFloat   = 12
        static let shadowOpacity: Double   = 0.06
        static let shadowRadius: CGFloat   = 4
        static let shadowY: CGFloat        = 2
        static let iconSize: CGFloat       = 36
    }

    var body: some View {
        VStack(spacing: 0) {
            sheetHeader
            Divider()

            if addresses.isEmpty {
                emptyState
            } else {
                addressList
            }

            addNewButton
                .padding(.horizontal, Layout.horizontalPad)
                .padding(.vertical, 16)
        }
        .background(Color.backGround.ignoresSafeArea())
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(20)
    }

    // MARK: - Header

    private var sheetHeader: some View {
        HStack {
            Text("Select Shipping Address")
                .appTextStyle(.heading2, color: .appBlack)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.grey150)
            }
        }
        .padding(.horizontal, Layout.horizontalPad)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Address List

    private var addressList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(addresses) { address in
                    addressRow(for: address)
                }
            }
            .padding(.horizontal, Layout.horizontalPad)
            .padding(.vertical, 16)
        }
    }

    private func addressRow(for address: Address) -> some View {
        let isSelected = selectedAddress?.id == address.id

        return Button {
            onSelect(address)
            dismiss()
        } label: {
            HStack(spacing: 12) {

                // Location icon
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.cyan50 : Color.grey50)
                        .frame(
                            width: Layout.iconSize,
                            height: Layout.iconSize
                        )
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(
                            isSelected ? .cyanPrimary : .grey150
                        )
                }

                // Address details
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(address.fullName)
                            .appTextStyle(.label, color: .appBlack)

                        // Default badge — informational only, no action
                        if address.isDefault {
                            Text("Default")
                                .appTextStyle(.caption, color: .cyanPrimary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.cyan50)
                                .cornerRadius(4)
                        }
                    }

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

                // Selection indicator
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
            .padding(Layout.horizontalPad)
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
                                isSelected ? Color.cyanPrimary : Color.clear,
                                lineWidth: 1.5
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 40))
                .foregroundColor(.grey100)

            Text("No saved addresses")
                .appTextStyle(.heading2, color: .appBlack)

            Text("Add a shipping address to continue.")
                .appTextStyle(.body, color: .grey150)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - Add New Button

    private var addNewButton: some View {
        Button {
            onAddNew()
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.cyanPrimary)
                Text("Add New Address")
                    .appTextStyle(.label, color: .cyanPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.cyan50)
            .cornerRadius(Layout.cornerRadius)
        }
    }
}

// MARK: - Preview

#Preview {
    Color.black.opacity(0.3)
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            CheckoutAddressPickerView(
                addresses: [
                    Address(
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
                    Address(
                        id: "2",
                        firstName: "Jane",
                        lastName: "Doe",
                        address1: "456 Park Ave",
                        address2: "Apt 7B",
                        city: "Brooklyn",
                        province: "NY",
                        country: "United States",
                        zip: "11201",
                        phone: "+1 555 000 5678",
                        isDefault: false
                    )
                ],
                selectedAddress: nil,
                onSelect: { _ in },
                onAddNew: {}
            )
        }
}
