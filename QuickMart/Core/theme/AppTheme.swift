//
//  AppTheme.swift
//  QuickMart
//
//  Created by Alaa Ayman on 28/06/2026.
//





import SwiftUI


enum AppColorScheme {
    case light
    case dark
}

struct AppTheme {
    let colorScheme: AppColorScheme

    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme == .dark ? .dark : .light
    }

    private var isDark: Bool { colorScheme == .dark }

    // MARK: - Text Colors
    var primaryText: Color {
        isDark ? .appWhite : .appBlack
    }
    var secondaryText: Color {
        isDark ? Color.appWhite.opacity(0.75) : Color.appBlack.opacity(0.65)
    }
    var captionText: Color {
        isDark ? Color.appWhite.opacity(0.50) : Color.appBlack.opacity(0.45)
    }
    var mutedText: Color {
        isDark ? Color.grey100 : Color.grey150
    }

  
    var primary: Color { .cyan }
    var primaryLight: Color { .cyan50 }


    var background: Color { .backGround }
    var cardBackground: Color {
        isDark ? Color.appBlack.opacity(0.60) : Color.appWhite
    }
    var cardStroke: Color {
        isDark ? Color.appWhite.opacity(0.12) : Color.grey100
    }
    var divider: Color {
        isDark ? Color.appWhite.opacity(0.12) : Color.appBlack.opacity(0.08)
    }
    var inputBorder: Color {
        isDark ? Color.grey150 : Color.grey100
    }
    var inputFocusedBorder: Color { .cyan }

 

   
    var secondaryButtonText: Color { .appBlack }
    var primaryButtonBackground: Color {
        isDark ? .cyan : .appBlack
    }
    var primaryButtonText: Color {
        isDark ? .appWhite : .appWhite
    }
    
 
    var error: Color { .appRed }
    var success: Color { .cyan }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

  
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 32
    }

   
    enum Button {
        static let height: CGFloat = 56
        static let verticalPadding: CGFloat = 18
        static let horizontalPadding: CGFloat = 16
    }
}

enum AppFonts {
    static let heading1: Font = .system(size: 28, weight: .bold)
    static let heading2: Font = .system(size: 24, weight: .bold)
    static let body: Font = .system(size: 14, weight: .regular)
    static let label: Font = .system(size: 14, weight: .medium)
    static let button: Font = .system(size: 16, weight: .semibold)
    static let caption: Font = .system(size: 12, weight: .regular)
}


private struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme(colorScheme: .light)
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}
