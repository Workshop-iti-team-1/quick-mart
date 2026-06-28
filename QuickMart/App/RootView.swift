import SwiftUI

struct RootView: View {
    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    @State private var router = AppRouter()

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
                    LoginView(router : router)
                case .signup:
                    SignupView(router: router)
                case .home:
                    SignupView(router: router)
                }
            }
        }
    }
}
#Preview {
    RootView()
}
