//
//  CartEventsBus.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 08/07/2026.
//

import Combine
import Foundation

final class CartEventsBus {
    static let shared = CartEventsBus()
    private init() {}

    /// Emits when the cart is modified (items added, removed, or updated).
    /// Subscribers should re-fetch the latest cart state.
    let cartUpdated = PassthroughSubject<Void, Never>()
    
    /// Emits when the cart is explicitly destroyed (checkout, logout, guest transition).
    /// Subscribers should immediately drop their local state to 0 or empty.
    let cartCleared = PassthroughSubject<Void, Never>()
}
