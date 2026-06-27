//
//  QuickMartApp.swift
//  QuickMart
//
//  Created by Ahmed El Sayyad Mohamed on 27/06/2026.
//

import SwiftUI

@main
struct QuickMartApp: App {
    
    @State private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
