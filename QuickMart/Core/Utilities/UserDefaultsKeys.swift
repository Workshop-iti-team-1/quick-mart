import Foundation

class UserDefaultsKeys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let customerAccessToken = "ShopifyCustomerAccessToken"
    static var cartId: String {
        return "ShopifyCartId_\(SessionManager.shared.currentUserId)"
    }
}
