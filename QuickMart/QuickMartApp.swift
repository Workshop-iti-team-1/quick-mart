//
//  QuickMartApp.swift
//  QuickMart
//
//  Created by Ahmed El Sayyad Mohamed on 27/06/2026.
//

import SwiftUI

@main
struct QuickMartApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
