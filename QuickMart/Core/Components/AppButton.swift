import SwiftUI

enum AppButtonStyle {
    case primary
    case secondary
}

struct AppButton: View {
    var title: String
    var style: AppButtonStyle = .primary
    var icon: String? = nil
    var customIcon: Image? = nil
    var verticalPadding: CGFloat = AppTheme.Button.verticalPadding
    var action: () -> Void

    @Environment(\.appTheme) var theme

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .appTextStyle(.button, color: textColor)
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(textColor)
                }
                if let customIcon = customIcon {
                    customIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, verticalPadding)
            .background(backgroundView)
        }
        .padding(.horizontal, AppTheme.Button.horizontalPadding)
    }

    private var textColor: Color {
        switch style {
        case .primary: return theme.primaryButtonText
        case .secondary: return theme.primary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                .fill(theme.primaryButtonBackground)
        case .secondary:
            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                .stroke(theme.cardStroke, lineWidth: 1.5)
        }
    }
}

  
#Preview {
    VStack(spacing: 20) {
        AppButton(title: "Primary Button") {}
        AppButton(title: "Primary with Icon", icon: "arrow.right") {}
        AppButton(title: "Secondary Button", style: .secondary) {}
    }
    .padding()
}

