//
//  QuickMartApp.swift
//  QuickMart
//
//  Created by Ahmed El Sayyad Mohamed on 27/06/2026.
//

import SwiftUI
//import FirebaseCore
@main
struct QuickMartApp: App {
    let persistenceController = PersistenceController.shared
    //    init() {
    //        FirebaseApp.configure()
    //    }
    @State private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                router.resolve(.home)
                    .navigationDestination(for: Route.self) { route in
                        router.resolve(route)
                    }
            }
            .environment(router) // Inject router into environment for deep View access
        }
    }
}


