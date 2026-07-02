//
//  CartRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

class CartRepositoryImpl: CartRepository {
    private let remoteDataSource: RemoteCartDataSource
    private let commonRemoteDataSource: CommonRemoteDataSourceProtocol
    
    init(remoteDataSource: RemoteCartDataSource, commonRemoteDataSource: CommonRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.commonRemoteDataSource = commonRemoteDataSource
    }
    
    private func getCartId() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.cartId)
    }
    
    private func saveCartId(_ id: String) {
        UserDefaults.standard.set(id, forKey: UserDefaultsKeys.cartId)
    }
    
    func getCart() async throws -> Cart? {
        guard let cartId = getCartId() else {
            return nil
        }
        
        let apiCart = try await commonRemoteDataSource.getCart(cartId: cartId)
        
        guard let apiCart = apiCart else {
            // Cart might be deleted or invalid, clear local id
            clearCart()
            return nil
        }
        
        return mapToCart(apiCart: apiCart)
    }
    
    func updateLine(lineId: String, quantity: Int) async throws -> Cart {
        guard let cartId = getCartId() else { throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Cart"]) }
        _ = try await remoteDataSource.updateLine(cartId: cartId, lineId: lineId, quantity: quantity)
        
        guard let updatedCart = try await getCart() else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch updated cart"])
        }
        return updatedCart
    }
    
    func removeLine(lineId: String) async throws -> Cart {
        guard let cartId = getCartId() else { throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Cart"]) }
        _ = try await remoteDataSource.removeLine(cartId: cartId, lineId: lineId)
        
        guard let updatedCart = try await getCart() else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch updated cart"])
        }
        return updatedCart
    }
    
    func applyDiscount(code: String) async throws -> Cart {
        guard let cartId = getCartId() else { throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Cart"]) }
        _ = try await remoteDataSource.applyDiscount(cartId: cartId, code: code)
        
        guard let updatedCart = try await getCart() else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch updated cart"])
        }
        return updatedCart
    }
    
    func clearCart() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cartId)
    }
    
    // MARK: - Mappers
    
    private func mapToCart(apiCart: ShopifyAPI.GetCartQuery.Data.Cart) -> Cart {
        let cost = CartCost(
            subtotalAmount: Double(apiCart.cost.subtotalAmount.amount) ?? 0.0,
            totalAmount: Double(apiCart.cost.totalAmount.amount) ?? 0.0,
            totalTaxAmount: Double(apiCart.cost.totalTaxAmount?.amount ?? "0.0"),
            currencyCode: apiCart.cost.totalAmount.currencyCode.rawValue
        )
        
        let lines = apiCart.lines.edges.map { edge in
            let node = edge.node
            
            var merchandiseVariant: ProductVariant? = nil
            if let variant = node.merchandise.asProductVariant {
                merchandiseVariant = ProductVariant(
                    id: variant.id,
                    title: variant.title,
                    price: Double(variant.price.amount) ?? 0.0,
                    compareAtPrice: Double(variant.compareAtPrice?.amount ?? "0.0"),
                    availableForSale: variant.availableForSale,
                    quantityAvailable: variant.quantityAvailable ?? 0,
                    imageURL: variant.image?.url,
                    productTitle: variant.product.title,
                    productVendor: variant.product.vendor
                )
            }
            
            let lineCost = CartLineCost(
                totalAmount: Double(node.cost.totalAmount.amount) ?? 0.0,
                amountPerQuantity: Double(node.cost.amountPerQuantity.amount),
                currencyCode: node.cost.totalAmount.currencyCode.rawValue
            )
            
            return CartLine(
                id: node.id,
                quantity: node.quantity,
                cost: lineCost,
                merchandise: merchandiseVariant ?? ProductVariant(id: "", title: "", price: 0, compareAtPrice: nil, availableForSale: false, quantityAvailable: 0, imageURL: nil, productTitle: "", productVendor: "")
            )
        }
        
        let discounts = apiCart.discountCodes.map { discount in
            CartDiscountCode(code: discount.code, applicable: discount.applicable)
        }
        
        return Cart(
            id: apiCart.id,
            checkoutUrl: apiCart.checkoutUrl,
            totalQuantity: apiCart.totalQuantity,
            cost: cost,
            lines: lines,
            discountCodes: discounts
        )
    }
    
    // Extra Mappers for mutations were removed because we just re-fetch the entire cart using getCart()
}
