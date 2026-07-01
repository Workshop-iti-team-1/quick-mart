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
    
    enum General {
        static let error = String(localized: "General_error", defaultValue: "Error")
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
