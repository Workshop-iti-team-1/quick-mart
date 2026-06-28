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
    @Environment(\.appTheme) var theme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack(spacing: 0) {
                Text(title)
                    .font(AppFonts.label)
                    .foregroundColor(theme.primaryText)
                if isRequired {
                    Text(" *")
                        .font(AppFonts.label)
                        .foregroundColor(theme.error)
                }
            }

            HStack {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(AppFonts.body)
                        .foregroundColor(theme.primaryText)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .font(AppFonts.body)
                        .foregroundColor(theme.primaryText)
                        .focused($isFocused)
                }
                if isSecure {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(theme.mutedText)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .frame(height: AppTheme.Button.height)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(
                        isFocused ? theme.inputFocusedBorder : theme.inputBorder,
                        lineWidth: 1.5
                    )
            )
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}

