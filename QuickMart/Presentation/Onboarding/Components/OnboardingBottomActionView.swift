import SwiftUI

struct OnboardingBottomActionView: View {
    @Binding var currentPage: Int
    @Binding var hasSeenOnboarding: Bool
    let items: [OnboardingItem]
    var router: AppRouter

    var body: some View {
        VStack(spacing: 32) {
            if currentPage < items.count - 1 {
                AppButton(title: "Next") {
                    withAnimation { currentPage += 1 }
                }
                .padding(.horizontal, 20)
            } else {
                HStack(spacing: 16) {
                    AppButton(title: "Login", style: .secondary) {
                        hasSeenOnboarding = true
                        router.push(.login)
                    }
                    AppButton(title: "Get Started", icon: "arrow.right") {
                        hasSeenOnboarding = true
                        router.push(.signup)
                    }
                }
                .padding(.horizontal, 20)
            }

            HStack(spacing: 8) {
                ForEach(0..<items.count, id: \.self) { index in
                    Capsule()
                        .fill(currentPage == index ? Color.cyanPrimary : Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 24 : 8, height: 8)
                }
            }
            .padding(.bottom, 20)
        }
        .animation(.easeInOut, value: currentPage)
    }
}

