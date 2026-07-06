//
//  VoucherRequirementView.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import SwiftUI

struct VoucherRequirementView: View {

    let requirement: String
    let isMet: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "info.circle.fill")
                .font(.system(size: 13))
                .foregroundColor(isMet ? .cyanPrimary : .appOrange)

            Text(requirement)
                .appTextStyle(.caption, color: isMet ? .appBlack : .appOrange)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isMet ? Color.cyan50 : Color.appOrange.opacity(0.08))
        )
    }
}

#Preview {
    VStack(spacing: 8) {
        VoucherRequirementView(
            requirement: "Requires at least 3 items in your cart.",
            isMet: false
        )
        VoucherRequirementView(
            requirement: "Minimum purchase: $100.",
            isMet: true
        )
    }
    .padding(16)
    .background(Color.backGround)
}
