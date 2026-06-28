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
    var color: Color = .black
    var verticalPadding: CGFloat = 16
    var action: () -> Void
    @Environment(\.colorScheme) var colorScheme
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
    }

    private var textColor: Color {
        switch style {
        case .primary:
            return colorScheme == .dark ? .black : .white
        case .secondary:
            return color
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
        case .secondary:
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
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
