import SwiftUI

struct RootView: View {
    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    @State private var router = AppRouter()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack(path: $router.path) {
            Group {
                if hasSeenOnboarding {
                    LoginView(router: router)
                } else {
                    OnboardingView(router: router)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    LoginView(router: router)
                case .signup:
                    SignupView(router: router)
                case .home:
                    Text("Home")
                }
            }
        }
        .environment(\.appTheme, AppTheme(colorScheme: colorScheme))
    }
}
#Preview {
    RootView()
}

