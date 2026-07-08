//
//  DiscountDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//


//
//  DiscountRemoteDataSourceProtocol.swift
//  QuickMart
//
//  Created by Alaa Ayman on 04/07/2026.
//

import Foundation

protocol DiscountDataSourceProtocol {
    func fetchActiveDiscounts() async throws -> [DiscountModel]
}
