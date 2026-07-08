//
//  AddressRowView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 03/07/2026.
//


//
//  AddressRowView.swift
//  QuickMart
//
//  Created by Alaa Ayman on 02/07/2026.
//
import SwiftUI

struct AddressRowView: View {
    let address: Address
    var onEdit: () -> Void
    var onSetDefault: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                onSetDefault()
            } label: {
                Image(systemName: address.isDefault ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(address.isDefault ? .cyanPrimary : .grey150)
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
            .disabled(address.isDefault)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(address.fullName).appTextStyle(.label, color: .appBlack)
                    if address.isDefault {
                        Text("Default")
                            .appTextStyle(.caption, color: .cyanPrimary)
                            .padding(.horizontal, 8).padding(.vertical, 2)
                            .background(Color.cyan50)
                            .cornerRadius(6)
                    }
                }
                Text(address.formattedAddress).appTextStyle(.body, color: .grayText)
                if let phone = address.phone {
                    Text(phone).appTextStyle(.caption, color: .grayText)
                }
            }

            Spacer()

            Button {
                onEdit()
            } label: {
                Image(systemName: "pencil").foregroundColor(.appBlack)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .id(address.id) // forces SwiftUI to treat this as a distinct, redrawable row per address id
    }
}
