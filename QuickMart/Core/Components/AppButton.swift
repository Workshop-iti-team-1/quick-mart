import SwiftUI

enum AppButtonStyle {
    case primary
    case secondary
}

struct AppButton: View {
    var title: String
    var style: AppButtonStyle = .primary
    var icon: String? = nil
    var action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if let icon = icon {
                    Image(systemName: icon)
                }
            }
            .appTextStyle(.button, color: textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(backgroundView)
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return colorScheme == .dark ? .black : .white
        case .secondary:
            return .cyanPrimary
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cyanPrimary)
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
