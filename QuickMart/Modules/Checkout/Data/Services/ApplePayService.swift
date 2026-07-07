//
//  ApplePayService.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import Foundation
import PassKit

final class ApplePayService: NSObject, ApplePayServiceProtocol {
    
    // We use a continuation to bridge the PassKit delegate callbacks into our async/await function.
    private var paymentContinuation: CheckedContinuation<ApplePayResult, Never>?
    
    // We store the result here. It defaults to .cancelled so that if the user just swipes
    // the sheet away, we know how to respond.
    private var paymentResult: ApplePayResult = .cancelled
    
    func canMakePayments() -> Bool {
        return PKPaymentAuthorizationController.canMakePayments()
    }
    
    func presentPaymentSheet(for amount: Double, currencyCode: String) async -> ApplePayResult {
        // 1. Configure the Payment Request
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.mock.quickmart" // Must match your .entitlements exact string
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
        request.countryCode = "US"
        request.currencyCode = currencyCode
        
        // 2. Define what the user is paying for
        let decimalAmount = NSDecimalNumber(value: amount)
        let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let roundedAmount = decimalAmount.rounding(accordingToBehavior: behavior)
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "QuickMart", amount: roundedAmount)
        ]
        
        // 3. Initialize the Controller
        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = self
        let canMake = PKPaymentAuthorizationController.canMakePayments()
            print("Apple Pay: Can make payments? \(canMake)")
        print("Apple Pay: Presenting sheet for amount: \(amount) \(currencyCode)")
        // 4. Wrap the delegate-based flow in a modern async task
        return await withCheckedContinuation { continuation in
            self.paymentContinuation = continuation
            self.paymentResult = .cancelled // Reset state
            
            controller.present { [weak self] successfullyPresented in
                if !successfullyPresented {
                    let error = NSError(
                        domain: "ApplePayService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to present Apple Pay sheet. Check entitlements and Simulator settings."]
                    )
                    self?.paymentResult = .failed(error)
                    self?.paymentContinuation?.resume(returning: self?.paymentResult ?? .cancelled)
                    self?.paymentContinuation = nil
                }
            }
        }
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePayService: PKPaymentAuthorizationControllerDelegate {
    
    /// Called when the user successfully authenticates with Face ID / Touch ID
    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // In a real production app, you would send `payment.token.paymentData` to your backend (Stripe, Adyen, etc.) here.
        // Since we are simulating, we will just grab the local transaction identifier and tell Apple it was successful.
        
        let transactionId = payment.token.transactionIdentifier
        self.paymentResult = .success(transactionIdentifier: transactionId)
        
        // This triggers the green checkmark animation on the Apple Pay sheet
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    /// Called when the sheet is completely finished (either through success, failure, or user cancellation)
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss { [weak self] in
            guard let self = self else { return }
            
            // Resume our async function and return the final result to the ViewModel
            self.paymentContinuation?.resume(returning: self.paymentResult)
            self.paymentContinuation = nil
        }
    }
}
