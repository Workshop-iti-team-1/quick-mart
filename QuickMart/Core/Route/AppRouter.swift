//
//  AppRouter.swift
//  QuickMart
//

import SwiftUI
import Observation

@Observable
final class AppRouter {
    
    var path = NavigationPath()
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer = .shared) {
        self.diContainer = diContainer
    }
    
    // MARK: - Navigation Intents
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
