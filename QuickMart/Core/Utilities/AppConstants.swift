import SwiftUI

struct OnboardingItem {
    let title: String
    let description: String
    let image: Image
}

struct AppConstants {
    static let onboardingItems = [
        OnboardingItem(
            title: "Explore a wide range of\nproducts",
            description: "Explore a wide range of products at your\nfingertips. QuickMart offers an extensive\ncollection to suit your needs.",
            image: .onboarding1
        ),
        OnboardingItem(
            title: "Unlock exclusive offers\nand discounts",
            description: "Get access to limited-time deals and special\npromotions available only to our valued\ncustomers.",
            image: .onboarding2
        ),
        OnboardingItem(
            title: "Safe and secure\npayments",
            description: "QuickMart employs industry-leading encryption\nand trusted payment gateways to safeguard your\nfinancial information.",
            image: .onboarding3
        )
    ]
}
