//
//  OrderEventBus.swift
//  QuickMart
//
//  Created by Mina_Wagdy on 08/07/2026.
//

import Combine
import Foundation

final class OrderEventsBus {
    static let shared = OrderEventsBus()
    private init() {}

    let orderPlaced = PassthroughSubject<PlacedOrder, Never>()
}
