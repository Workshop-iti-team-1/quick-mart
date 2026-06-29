// App/Navigation/RootView.swift

import SwiftUI

struct RootView: View {

    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            Group {
                if hasSeenOnboarding {
                    LoginView(router: router)
                } else {
                    OnboardingView(router: router)
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
}
