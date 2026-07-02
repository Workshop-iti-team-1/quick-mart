//
//  CartRepositoryImpl.swift
//  QuickMart
//
//  Created by siam on 2/07/2026.
//

import Foundation

class CartRepositoryImpl: CartRepository {
    private let remoteDataSource: RemoteCartDataSource
    
    init(remoteDataSource: RemoteCartDataSource) {
        self.remoteDataSource = remoteDataSource
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
        
        let apiCart = try await remoteDataSource.getCart(cartId: cartId)
        
        guard let apiCart = apiCart else {
            // Cart might be deleted or invalid, clear local id
            clearCart()
            return nil
        }
        
        return mapToCart(apiCart: apiCart)
    }
    
    func createCart() async throws -> Cart {
        let result = try await remoteDataSource.createCart(variantId: nil, quantity: nil)
        guard let apiCart = result?.cart else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create cart"])
        }
        
        saveCartId(apiCart.id)
        return mapToCart(apiCart: apiCart)
    }
    
    func addLine(variantId: String, quantity: Int) async throws -> Cart {
        let cartId = try await ensureCartExists()
        let result = try await remoteDataSource.addLine(cartId: cartId, variantId: variantId, quantity: quantity)
        
        guard let apiCart = result?.cart else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to add item to cart"])
        }
        return mapToCart(apiCart: apiCart)
    }
    
    func updateLine(lineId: String, quantity: Int) async throws -> Cart {
        let cartId = try await ensureCartExists()
        let result = try await remoteDataSource.updateLine(cartId: cartId, lineId: lineId, quantity: quantity)
        
        guard let apiCart = result?.cart else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to update item in cart"])
        }
        return mapToCart(apiCart: apiCart)
    }
    
    func removeLine(lineId: String) async throws -> Cart {
        let cartId = try await ensureCartExists()
        let result = try await remoteDataSource.removeLine(cartId: cartId, lineId: lineId)
        
        guard let apiCart = result?.cart else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to remove item from cart"])
        }
        return mapToCart(apiCart: apiCart)
    }
    
    func applyDiscount(code: String) async throws -> Cart {
        let cartId = try await ensureCartExists()
        let result = try await remoteDataSource.applyDiscount(cartId: cartId, code: code)
        
        guard let apiCart = result?.cart else {
            throw NSError(domain: "Cart", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to apply discount"])
        }
        return mapToCart(apiCart: apiCart)
    }
    
    func clearCart() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.cartId)
    }
    
    private func ensureCartExists() async throws -> String {
        if let id = getCartId() {
            return id
        }
        let newCart = try await createCart()
        return newCart.id
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
    
    // Create Cart Mapper
    private func mapToCart(apiCart: ShopifyAPI.CreateCartMutation.Data.CartCreate.Cart) -> Cart {
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
                    compareAtPrice: nil, // Not in this query
                    availableForSale: variant.availableForSale,
                    quantityAvailable: variant.quantityAvailable ?? 0,
                    imageURL: variant.image?.url,
                    productTitle: variant.product.title,
                    productVendor: variant.product.vendor
                )
            }
            
            let lineCost = CartLineCost(
                totalAmount: Double(node.cost.totalAmount.amount) ?? 0.0,
                amountPerQuantity: nil,
                currencyCode: node.cost.totalAmount.currencyCode.rawValue
            )
            
            return CartLine(
                id: node.id,
                quantity: node.quantity,
                cost: lineCost,
                merchandise: merchandiseVariant ?? ProductVariant(id: "", title: "", price: 0, compareAtPrice: nil, availableForSale: false, quantityAvailable: 0, imageURL: nil, productTitle: "", productVendor: "")
            )
        }
        
        return Cart(
            id: apiCart.id,
            checkoutUrl: apiCart.checkoutUrl,
            totalQuantity: apiCart.totalQuantity,
            cost: cost,
            lines: lines,
            discountCodes: []
        )
    }
    
    // Add Lines Mapper
    private func mapToCart(apiCart: ShopifyAPI.AddCartLinesMutation.Data.CartLinesAdd.Cart) -> Cart {
        let cost = CartCost(
            subtotalAmount: Double(apiCart.cost.subtotalAmount.amount) ?? 0.0,
            totalAmount: Double(apiCart.cost.totalAmount.amount) ?? 0.0,
            totalTaxAmount: nil,
            currencyCode: apiCart.cost.totalAmount.currencyCode.rawValue
        )
        
        let lines = apiCart.lines.edges.map { edge in
            let node = edge.node
            var merchandiseVariant: ProductVariant? = nil
            if let variant = node.merchandise.asProductVariant {
                merchandiseVariant = ProductVariant(
                    id: variant.id, title: variant.title, price: Double(variant.price.amount) ?? 0.0,
                    compareAtPrice: nil, availableForSale: true, quantityAvailable: variant.quantityAvailable ?? 0,
                    imageURL: nil, productTitle: variant.product.title, productVendor: variant.product.vendor
                )
            }
            return CartLine(
                id: node.id, quantity: node.quantity,
                cost: CartLineCost(totalAmount: 0.0, amountPerQuantity: nil, currencyCode: ""),
                merchandise: merchandiseVariant ?? ProductVariant(id: "", title: "", price: 0, compareAtPrice: nil, availableForSale: false, quantityAvailable: 0, imageURL: nil, productTitle: "", productVendor: "")
            )
        }
        
        return Cart(id: apiCart.id, checkoutUrl: "", totalQuantity: apiCart.totalQuantity, cost: cost, lines: lines, discountCodes: [])
    }
    
    // Update Lines Mapper
    private func mapToCart(apiCart: ShopifyAPI.UpdateCartLinesMutation.Data.CartLinesUpdate.Cart) -> Cart {
        let cost = CartCost(
            subtotalAmount: Double(apiCart.cost.subtotalAmount.amount) ?? 0.0,
            totalAmount: Double(apiCart.cost.totalAmount.amount) ?? 0.0,
            totalTaxAmount: nil,
            currencyCode: apiCart.cost.totalAmount.currencyCode.rawValue
        )
        return Cart(id: apiCart.id, checkoutUrl: "", totalQuantity: apiCart.totalQuantity, cost: cost, lines: [], discountCodes: [])
    }
    
    // Remove Lines Mapper
    private func mapToCart(apiCart: ShopifyAPI.RemoveCartLinesMutation.Data.CartLinesRemove.Cart) -> Cart {
        let cost = CartCost(
            subtotalAmount: Double(apiCart.cost.subtotalAmount.amount) ?? 0.0,
            totalAmount: Double(apiCart.cost.totalAmount.amount) ?? 0.0,
            totalTaxAmount: nil,
            currencyCode: apiCart.cost.totalAmount.currencyCode.rawValue
        )
        return Cart(id: apiCart.id, checkoutUrl: "", totalQuantity: apiCart.totalQuantity, cost: cost, lines: [], discountCodes: [])
    }
    
    // Apply Discount Mapper
    private func mapToCart(apiCart: ShopifyAPI.ApplyDiscountCodeMutation.Data.CartDiscountCodesUpdate.Cart) -> Cart {
        let cost = CartCost(
            subtotalAmount: Double(apiCart.cost.subtotalAmount.amount) ?? 0.0,
            totalAmount: Double(apiCart.cost.totalAmount.amount) ?? 0.0,
            totalTaxAmount: nil,
            currencyCode: apiCart.cost.totalAmount.currencyCode.rawValue
        )
        let discounts = apiCart.discountCodes.map { CartDiscountCode(code: $0.code, applicable: $0.applicable) }
        return Cart(id: apiCart.id, checkoutUrl: "", totalQuantity: 0, cost: cost, lines: [], discountCodes: discounts)
    }
}
