//
//  RequestApplePayPaymentUseCase.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//

import Foundation

protocol RequestApplePayPaymentUseCaseProtocol {
    func canMakePayments() -> Bool
    func execute(amount: Double, currencyCode: String) async -> ApplePayResult
}

final class RequestApplePayPaymentUseCase: RequestApplePayPaymentUseCaseProtocol {
    
    private let applePayService: ApplePayServiceProtocol
    
    init(applePayService: ApplePayServiceProtocol) {
        self.applePayService = applePayService
    }
    
    func canMakePayments() -> Bool {
        return applePayService.canMakePayments()
    }
    
    func execute(amount: Double, currencyCode: String) async -> ApplePayResult {
        // Here you could add business logic, like ensuring the amount is > 0,
        // analytics tracking, or formatting the currency code before sending it to the service.
        guard amount > 0 else {
            return .failed(NSError(domain: "Checkout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid amount"]))
        }
        
        return await applePayService.presentPaymentSheet(for: amount, currencyCode: currencyCode)
    }
}
