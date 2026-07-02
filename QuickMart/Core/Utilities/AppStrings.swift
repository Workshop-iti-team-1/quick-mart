import Foundation

enum AppStrings {
    enum Auth {
        static let login = String(localized: "Auth_login", defaultValue: "Login")
        static let signup = String(localized: "Auth_signup", defaultValue: "Signup")
        static let dontHaveAccount = String(localized: "Auth_dontHaveAccount", defaultValue: "Don't have an account?")
        static let alreadyHaveAccount = String(localized: "Auth_alreadyHaveAccount", defaultValue: "Already have an account?")
        static let firstName = String(localized: "Auth_firstName", defaultValue: "First Name")
        static let lastName = String(localized: "Auth_lastName", defaultValue: "Last Name")
        static let email = String(localized: "Auth_email", defaultValue: "Email")
        static let password = String(localized: "Auth_password", defaultValue: "Password")
        static let confirmPassword = String(localized: "Auth_confirmPassword", defaultValue: "Confirm Password")
        
        static let enterFirstName = String(localized: "Auth_enterFirstName", defaultValue: "Enter your first name")
        static let enterLastName = String(localized: "Auth_enterLastName", defaultValue: "Enter your last name")
        static let enterEmail = String(localized: "Auth_enterEmail", defaultValue: "Enter your email")
        static let enterPassword = String(localized: "Auth_enterPassword", defaultValue: "Enter your password")
        static let enterConfirmPassword = String(localized: "Auth_enterConfirmPassword", defaultValue: "Re-enter your password")
        
        static let loading = String(localized: "Auth_loading", defaultValue: "Loading...")
        static let forgotPassword = String(localized: "Auth_forgotPassword", defaultValue: "Forgot password?")
        static let forgotPasswordTitle = String(localized: "Auth_forgotPasswordTitle", defaultValue: "Forgot Password")
        static let forgotPasswordSubtitle = String(localized: "Auth_forgotPasswordSubtitle", defaultValue: "Enter your email address and we will send you a link to reset your password.")
        static let sendResetLink = String(localized: "Auth_sendResetLink", defaultValue: "Send Reset Link")
        static let resetLinkSent = String(localized: "Auth_resetLinkSent", defaultValue: "A reset link has been sent to your email.")
        static let backToLogin = String(localized: "Auth_backToLogin", defaultValue: "Back to Login")
        static let loginWithGoogle = String(localized: "Auth_loginWithGoogle", defaultValue: "Login with Google")
        static let signupWithGoogle = String(localized: "Auth_signupWithGoogle", defaultValue: "Signup with Google")
        static let createAccount = String(localized: "Auth_createAccount", defaultValue: "Create Account")
        static let loginAsGuest = String(localized: "Auth_loginAsGuest", defaultValue: "Login as guest")
        static let termsPrefix = String(localized: "Auth_termsPrefix", defaultValue: "By login, you agree to our ")
        static let privacyPolicy = String(localized: "Auth_privacyPolicy", defaultValue: "Privacy Policy")
        static let and = String(localized: "Auth_and", defaultValue: " and ")
        static let termsConditions = String(localized: "Auth_termsConditions", defaultValue: "Terms & Conditions")
        
        enum Validation {
            static let emptyEmailPassword = String(localized: "Auth_validation_emptyEmailPassword", defaultValue: "Please enter email and password.")
            static let invalidEmail = String(localized: "Auth_validation_invalidEmail", defaultValue: "Please enter a valid email address.")
            static let emptyName = String(localized: "Auth_validation_emptyName", defaultValue: "Please enter your first and last name.")
            static let shortPassword = String(localized: "Auth_validation_shortPassword", defaultValue: "Password must be at least 6 characters.")
            static let passwordsNotMatch = String(localized: "Auth_validation_passwordsNotMatch", defaultValue: "Passwords do not match.")
        }
    }
    
    enum Cart {
        static let myCart = String(localized: "Cart_myCart", defaultValue: "My Cart")
        static let voucherCode = String(localized: "Cart_voucherCode", defaultValue: "Voucher Code")
        static let orderInfo = String(localized: "Cart_orderInfo", defaultValue: "Order Info")
        static let subtotal = String(localized: "Cart_subtotal", defaultValue: "Subtotal")
        static let shippingCost = String(localized: "Cart_shippingCost", defaultValue: "Shipping Cost")
        static let total = String(localized: "Cart_total", defaultValue: "Total")
        static let checkout = String(localized: "Cart_checkout", defaultValue: "Checkout")
        
        static let emptyCartTitle = String(localized: "Cart_emptyCartTitle", defaultValue: "Your cart is empty")
        static let emptyCartMessage = String(localized: "Cart_emptyCartMessage", defaultValue: "Looks like you have not added anything in your cart. Go ahead and explore top categories.")
        static let exploreCategories = String(localized: "Cart_exploreCategories", defaultValue: "Explore Categories")
        
        static let guestCartTitle = String(localized: "Cart_guestCartTitle", defaultValue: "Login to view cart")
        static let guestCartMessage = String(localized: "Cart_guestCartMessage", defaultValue: "Please login to your account to view your cart and checkout.")
        static let login = String(localized: "Cart_login", defaultValue: "Login")
        
        static let enterVoucherCode = String(localized: "Cart_enterVoucherCode", defaultValue: "Enter Voucher Code")
        static let apply = String(localized: "Cart_apply", defaultValue: "Apply")
        static let discountAppliedMessage = String(localized: "Cart_discountAppliedMessage", defaultValue: "The discount code has been applied successfully.")
    }
    
    enum ProductDetails {
        static let topRated = String(localized: "ProductDetails_topRated", defaultValue: "Top Rated")
        static let freeShipping = String(localized: "ProductDetails_freeShipping", defaultValue: "Free Shipping")
        static let readMore = String(localized: "ProductDetails_readMore", defaultValue: "Read more")
        static let color = String(localized: "ProductDetails_color", defaultValue: "Color")
        static let size = String(localized: "ProductDetails_size", defaultValue: "Size")
        static let quantity = String(localized: "ProductDetails_quantity", defaultValue: "Quantity")
        static let buyNow = String(localized: "ProductDetails_buyNow", defaultValue: "Buy Now")
        static let addToCart = String(localized: "ProductDetails_addToCart", defaultValue: "Add To Cart")
        static let addedToCartMessage = String(localized: "ProductDetails_addedToCartMessage", defaultValue: "The product has been added to your cart")
        static let viewCart = String(localized: "ProductDetails_viewCart", defaultValue: "View Cart")
        static let outOfStock = String(localized: "ProductDetails_outOfStock", defaultValue: "This product is currently out of stock.")
        static let selectOptionsFirst = String(localized: "ProductDetails_selectOptionsFirst", defaultValue: "Please select options first or variant unavailable")
    }
    
    enum General {
        static let error = String(localized: "General_error", defaultValue: "Error")
        static let success = String(localized: "General_success", defaultValue: "Success")
        static let ok = String(localized: "General_ok", defaultValue: "OK")
    }
    
    enum FirebaseError {
        static let invalidEmail = String(localized: "FirebaseError_invalidEmail", defaultValue: "The email address is invalid.")
        static let wrongPassword = String(localized: "FirebaseError_wrongPassword", defaultValue: "Incorrect password. Please try again.")
        static let emailAlreadyInUse = String(localized: "FirebaseError_emailAlreadyInUse", defaultValue: "This email is already registered. Please login instead.")
        static let weakPassword = String(localized: "FirebaseError_weakPassword", defaultValue: "Password is too weak. Please use at least 6 characters.")
        static let userNotFound = String(localized: "FirebaseError_userNotFound", defaultValue: "No account found with this email.")
        static let networkError = String(localized: "FirebaseError_networkError", defaultValue: "Network error. Please check your connection.")
    }
    
    enum Onboarding {
        static let skipForNow = String(localized: "Onboarding_skipForNow", defaultValue: "Skip for now")
        static let next = String(localized: "Onboarding_next", defaultValue: "Next")
        static let getStarted = String(localized: "Onboarding_getStarted", defaultValue: "Get Started")
        
        static let title1 = String(localized: "Onboarding_title1", defaultValue: "Explore a wide range of\nproducts")
        static let desc1 = String(localized: "Onboarding_desc1", defaultValue: "Explore a wide range of products at your\nfingertips. QuickMart offers an extensive\ncollection to suit your needs.")
        
        static let title2 = String(localized: "Onboarding_title2", defaultValue: "Unlock exclusive offers\nand discounts")
        static let desc2 = String(localized: "Onboarding_desc2", defaultValue: "Get access to limited-time deals and special\npromotions available only to our valued\ncustomers.")
        
        static let title3 = String(localized: "Onboarding_title3", defaultValue: "Safe and secure\npayments")
        static let desc3 = String(localized: "Onboarding_desc3", defaultValue: "QuickMart employs industry-leading encryption\nand trusted payment gateways to safeguard your\nfinancial information.")
    }
    
    enum Network {
        static let invalidURL = String(localized: "Network_invalidURL", defaultValue: "Invalid API URL.")
        static func encodingFailed(_ error: String) -> String {
            String(localized: "Network_encodingFailed", defaultValue: "Request encoding failed: \(error)")
        }
        static func requestFailed(_ code: Int) -> String {
            String(localized: "Network_requestFailed", defaultValue: "Request failed with HTTP \(code).")
        }
        static func decodingFailed(_ error: String) -> String {
            String(localized: "Network_decodingFailed", defaultValue: "Response decoding failed: \(error)")
        }
        static let noData = String(localized: "Network_noData", defaultValue: "No data received.")
        static let unauthorized = String(localized: "Network_unauthorized", defaultValue: "Invalid Storefront Access Token.")
        static let rateLimited = String(localized: "Network_rateLimited", defaultValue: "Too many requests. Please slow down.")
    }
}
