//
//  CustomTextField.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//


import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isRequired: Bool = true

    @State private var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text(title)
                    .appTextStyle(.label, color: .primary)
                if isRequired {
                    Text(" *")
                        .appTextStyle(.label, color: .appRed)
                }
            }

            HStack {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .appTextStyle(.body, color: .primary)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .appTextStyle(.body, color: .primary)
                        .focused($isFocused)
                }
                if isSecure {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(Color.grey150)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color.cyanPrimary : Color.grey150.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
        }
    }
}

