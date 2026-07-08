import SwiftUI

struct AppTextStyle: ViewModifier {
    enum TextStyle {
        case heading1
        case heading2
        case heading3
        case body
        case button
        case caption
        case label
    }

    var style: TextStyle
    var color: Color

    func body(content: Content) -> some View {
        switch style {
        case .heading1:
            content
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
        case .heading2:
            content
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
        case .heading3:
            content
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
        case .body:
            content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(color)
        case .button:
            content
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
        case .caption:
            content
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(color)
        case .label:
            content
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
        }
    }
}

extension View {
    func appTextStyle(_ style: AppTextStyle.TextStyle, color: Color = .primary)
        -> some View
    {
        self.modifier(AppTextStyle(style: style, color: color))
    }
}
