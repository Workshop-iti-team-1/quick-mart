//
//  ProfileRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 04/07/2026.
//

import Foundation

class ProfileRepositoryImpl: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol
    
    init(remoteDataSource: ProfileRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getCustomerOrders(first: Int, after: String?) async throws -> (orders: [OrderEntity], hasNextPage: Bool, endCursor: String?) {
        let data = try await remoteDataSource.getCustomerOrders(first: first, after: after)
        
        guard let ordersData = data.customer?.orders else {
            return (orders: [], hasNextPage: false, endCursor: nil)
        }
        
        let mappedOrders: [OrderEntity] = ordersData.edges.compactMap { edge in
            let node = edge.node
            
            // Map Line Items
            let lineItems: [OrderLineItemEntity] = node.lineItems.edges.compactMap { lineItemEdge in
                let lineNode = lineItemEdge.node
                return OrderLineItemEntity(
                    id: lineNode.variant?.id ?? "",
                    title: lineNode.title,
                    quantity: lineNode.quantity,
                    originalTotalPrice: Double(lineNode.originalTotalPrice.amount) ?? 0.0,
                    variantTitle: lineNode.variant?.title,
                    imageURL: lineNode.variant?.image?.url
                )
            }
            
            // Map Discount Applications
            let discounts: [DiscountApplicationEntity] = node.discountApplications.edges.compactMap { discountEdge in
                let discountNode = discountEdge.node
                if let codeApp = discountNode.asDiscountCodeApplication {
                    var percentage: Double? = nil
                    var amount: Double? = nil
                    
                    if let pValue = codeApp.value.asPricingPercentageValue {
                        percentage = pValue.percentage
                    } else if let mValue = codeApp.value.asMoneyV2 {
                        amount = Double(mValue.amount)
                    }
                    
                    return DiscountApplicationEntity(
                        code: codeApp.code,
                        percentage: percentage,
                        amount: amount
                    )
                }
                return nil
            }
            
            // Map Shipping Address
            var shippingAddress: OrderShippingAddressEntity? = nil
            if let addressNode = node.shippingAddress {
                shippingAddress = OrderShippingAddressEntity(
                    firstName: addressNode.firstName,
                    lastName: addressNode.lastName,
                    address1: addressNode.address1,
                    city: addressNode.city,
                    country: addressNode.country,
                    phone: addressNode.phone
                )
            }
            
            let processedAtDate: Date
            if let dateStr = node.processedAt as? String {
                processedAtDate = ISO8601DateFormatter().date(from: dateStr) ?? Date()
            } else {
                processedAtDate = Date()
            }

            return OrderEntity(
                id: node.id,
                orderNumber: node.orderNumber,
                processedAt: processedAtDate,
                financialStatus: node.financialStatus?.rawValue ?? "",
                fulfillmentStatus: node.fulfillmentStatus.rawValue ,
                currentTotalPrice: Double(node.currentTotalPrice.amount) ?? 0.0,
                currentSubtotalPrice: Double(node.currentSubtotalPrice.amount) ?? 0.0,
                currencyCode: node.currentTotalPrice.currencyCode.rawValue,
                discountApplications: discounts,
                lineItems: lineItems,
                shippingAddress: shippingAddress
            )
        }
        
        return (
            orders: mappedOrders,
            hasNextPage: ordersData.pageInfo.hasNextPage,
            endCursor: ordersData.pageInfo.endCursor
        )
    }
}
