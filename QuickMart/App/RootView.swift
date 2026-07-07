import SwiftUI

struct RootView: View {
    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding:
        Bool = false
    @Environment(AppRouter.self) private var router
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            currentView
                .navigationDestination(for: Route.self) { route in
                    router.destination(for: route)
                }
        }.tint(Color.cyanPrimary)
    }

    @ViewBuilder
    private var currentView: some View {
        if !hasSeenOnboarding {
            OnboardingView()
        } else {
            switch sessionManager.currentState {
            case .loading:
                ProgressView()
            case .unauthenticated:
                LoginView()
            case .guest, .loggedIn:
                MainTabView()
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AppRouter())
        .environmentObject(SessionManager.shared)
}
