// App/Navigation/RootView.swift

import SwiftUI

struct RootView: View {

    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    @Environment(AppRouter.self) private var router
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            Group {
                switch sessionManager.currentState {
                case .loading:
                    ProgressView()
                case .unauthenticated:
                    if hasSeenOnboarding {
                        LoginView(router: router)
                    } else {
                        OnboardingView(router: router)
                    }
                case .guest, .loggedIn:
                    MainTabView(router: router)
                }
            }
            .navigationDestination(for: Route.self) { route in
                router.destination(for: route)
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppRouter())
        .environmentObject(SessionManager.shared)
}
