import SwiftUI

struct OnboardingItem {
    let title: String
    let description: String
    let image: Image
}

struct AppConstants {
    static let defultAppCurrency = "USD"
    static let onboardingItems = [
        OnboardingItem(
            title: AppStrings.Onboarding.title1,
            description: AppStrings.Onboarding.desc1,
            image: .onboarding1
        ),
        OnboardingItem(
            title: AppStrings.Onboarding.title2,
            description: AppStrings.Onboarding.desc2,
            image: .onboarding2
        ),
        OnboardingItem(
            title: AppStrings.Onboarding.title3,
            description: AppStrings.Onboarding.desc3,
            image: .onboarding3
        )
    ]
}
