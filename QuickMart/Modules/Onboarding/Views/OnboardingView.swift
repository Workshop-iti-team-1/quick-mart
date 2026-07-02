import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage(UserDefaultsKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool = false
    @Environment(AppRouter.self) private var router
    let items = AppConstants.onboardingItems

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.backGround.ignoresSafeArea()
                VStack(spacing: 0) {
                    OnboardingTopCardView(
                        currentPage: $currentPage,
                        hasSeenOnboarding: $hasSeenOnboarding,
                        items: items,
                        geometry: geometry
                    )
                    Spacer()
                    OnboardingTextContainerView(currentPage: $currentPage, items: items)
                    Spacer()
                    OnboardingBottomActionView(
                        currentPage: $currentPage,
                        hasSeenOnboarding: $hasSeenOnboarding,
                        items: items,
                        router: router
                    )
                }
            }
        }
    }
}
