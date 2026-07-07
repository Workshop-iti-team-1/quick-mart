//
//  QuickMartApp.swift
//  QuickMart
//
//  Created by Ahmed El Sayyad Mohamed on 27/06/2026.
//

import Firebase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        SessionManager.shared.configure()

        // MARK: - Global Navigation Bar Styling

        // 1. Change the back chevron arrow to cyanPrimary universally
        if let cyanColor = UIColor(named: "cyanPrimary") {
            UINavigationBar.appearance().tintColor = cyanColor
        }

        // 2. Hide the "Back" text globally (makes the text clear/invisible)
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()  // Maintains standard iOS blur/translucency
        appearance.backButtonAppearance = backButtonAppearance

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        // Set global tint for UIKit-based ProgressViews
        if let cyanColor = UIColor(named: "cyanPrimary") {
            UIProgressView.appearance().progressTintColor = cyanColor
        }

        return true
    }
}

@main
struct QuickMartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var router = AppRouter()
    @StateObject private var sessionManager = DIContainer.shared.sessionManager
    @StateObject private var currencyManager: CurrencyManagerService
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    init() {
        let manager = DIContainer.shared.makeCurrencyManagerService()
        _currencyManager = StateObject(wrappedValue: manager)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .environmentObject(sessionManager)
                .environmentObject(currencyManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .task {
                    await currencyManager.loadRatesIfNeeded()
                }
        }
    }
}
