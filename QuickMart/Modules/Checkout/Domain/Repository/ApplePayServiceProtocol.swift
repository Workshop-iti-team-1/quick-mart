//
//  ApplePayServiceProtocol.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 06/07/2026.
//
import Foundation

public enum ApplePayResult {
    case success(transactionIdentifier: String)
    case cancelled
    case failed(Error)
}

public protocol ApplePayServiceProtocol {
    /// Checks if the device supports Apple Pay and has cards configured (or is a simulator)
    func canMakePayments() -> Bool
    
    /// Presents the Apple Pay sheet and waits for the user's action
    func presentPaymentSheet(for amount: Double, currencyCode: String) async -> ApplePayResult
}
