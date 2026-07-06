//
//  QuickMartApp.swift
//  QuickMart
//
//  Created by Ahmed El Sayyad Mohamed on 27/06/2026.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        SessionManager.shared.configure()
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
