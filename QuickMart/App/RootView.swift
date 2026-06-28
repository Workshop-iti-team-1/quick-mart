import SwiftUI

struct RootView: View {
    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                Text("Login / Home Screen")
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    RootView()
}
